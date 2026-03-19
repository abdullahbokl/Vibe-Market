import Stripe from "https://esm.sh/stripe@18.1.1";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.57.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const stripeSecretKey = Deno.env.get("STRIPE_SECRET_KEY") ?? "";

    if (!supabaseUrl || !serviceRoleKey || !stripeSecretKey) {
      throw new Error(
        "SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, and STRIPE_SECRET_KEY are required.",
      );
    }

    const authorizationHeader = request.headers.get("Authorization") ?? "";
    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      global: {
        headers: {
          Authorization: authorizationHeader,
        },
      },
      auth: { persistSession: false },
    });

    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      throw new Error("Authenticated user is required for checkout.");
    }

    const body = await request.json();
    const items = Array.isArray(body.items) ? body.items : [];
    const idempotencyKey = String(body.idempotency_key ?? "");

    if (!idempotencyKey || items.length === 0) {
      throw new Error("Items and idempotency_key are required.");
    }

    const stripe = new Stripe(stripeSecretKey, { apiVersion: "2025-02-24.acacia" });
    const normalizedItems = items.map((item: Record<string, unknown>) => ({
      product_id: String(item.product_id ?? ""),
      quantity: Math.max(1, Number(item.quantity ?? 1)),
    }));

    const { data: existingOrder } = await supabase
      .from("orders")
      .select(
        "id, payment_intent_id, subtotal_cents, shipping_cents, total_cents, currency_code, order_status",
      )
      .eq("user_id", user.id)
      .eq("idempotency_key", idempotencyKey)
      .maybeSingle();

    if (
      typeof existingOrder?.payment_intent_id === "string" &&
      existingOrder.payment_intent_id.length > 0
    ) {
      const existingIntent = await stripe.paymentIntents.retrieve(
        existingOrder.payment_intent_id,
      );
      if (typeof existingIntent.client_secret !== "string") {
        throw new Error("Existing payment intent is missing a client secret.");
      }

      return Response.json(
        {
          order_id: existingOrder.id,
          client_secret: existingIntent.client_secret,
        },
        { headers: corsHeaders },
      );
    }

    let orderId = typeof existingOrder?.id === "string" ? existingOrder.id : "";
    let subtotalCents = Number(existingOrder?.subtotal_cents ?? 0);
    let shippingCents = Number(existingOrder?.shipping_cents ?? 0);
    let totalCents = Number(existingOrder?.total_cents ?? 0);
    let currencyCode = String(existingOrder?.currency_code ?? "USD");

    if (!orderId) {
      const { data: createdOrder, error: createOrderError } = await supabase.rpc(
        "create_checkout_order",
        {
          checkout_user_id: user.id,
          checkout_idempotency_key: idempotencyKey,
          checkout_items: normalizedItems,
          payment_intent_identifier: null,
        },
      );

      if (createOrderError) {
        throw createOrderError;
      }

      const checkoutOrder = Array.isArray(createdOrder)
        ? createdOrder[0]
        : createdOrder;

      if (!checkoutOrder || typeof checkoutOrder !== "object") {
        throw new Error("Checkout order creation returned no payload.");
      }

      orderId = String(checkoutOrder.order_id ?? "");
      subtotalCents = Number(checkoutOrder.subtotal_cents ?? 0);
      shippingCents = Number(checkoutOrder.shipping_cents ?? 0);
      totalCents = Number(checkoutOrder.total_cents ?? 0);
      currencyCode = String(checkoutOrder.currency_code ?? "USD");
    }

    if (!orderId || totalCents <= 0) {
      throw new Error("Checkout order payload was incomplete.");
    }

    try {
      const paymentIntent = await stripe.paymentIntents.create(
        {
          amount: totalCents,
          currency: currencyCode.toLowerCase(),
          metadata: {
            user_id: user.id,
            order_id: orderId,
            idempotency_key: idempotencyKey,
          },
        },
        {
          idempotencyKey,
        },
      );

      const { error: updateOrderError } = await supabase
        .from("orders")
        .update({
          payment_intent_id: paymentIntent.id,
        })
        .eq("id", orderId)
        .is("payment_intent_id", null);

      if (updateOrderError) {
        throw updateOrderError;
      }

      return Response.json(
        {
          order_id: orderId,
          client_secret: paymentIntent.client_secret,
          subtotal_cents: subtotalCents,
          shipping_cents: shippingCents,
          total_cents: totalCents,
          currency_code: currencyCode,
        },
        { headers: corsHeaders },
      );
    } catch (error) {
      await supabase.rpc("fail_order_payment", {
        target_order_id: orderId,
        failure_status: "payment_failed",
      });
      throw error;
    }
  } catch (error) {
    return Response.json(
      {
        error: error instanceof Error ? error.message : "Checkout intent failed",
      },
      { headers: corsHeaders, status: 500 },
    );
  }
});
