import Stripe from "https://esm.sh/stripe@18.1.1";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.57.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, stripe-signature",
};

Deno.serve(async (request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const stripeSecretKey = Deno.env.get("STRIPE_SECRET_KEY") ?? "";
    const stripeWebhookSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET") ?? "";

    if (
      !supabaseUrl ||
      !serviceRoleKey ||
      !stripeSecretKey ||
      !stripeWebhookSecret
    ) {
      throw new Error(
        "SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, STRIPE_SECRET_KEY, and STRIPE_WEBHOOK_SECRET are required.",
      );
    }

    const signature = request.headers.get("stripe-signature") ?? "";
    if (!signature) {
      throw new Error("Missing Stripe-Signature header.");
    }

    const stripe = new Stripe(stripeSecretKey, {
      apiVersion: "2025-02-24.acacia",
    });
    const payload = await request.text();
    const event = await stripe.webhooks.constructEventAsync(
      payload,
      signature,
      stripeWebhookSecret,
    );

    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false },
    });

    const { data: existingEvent, error: existingEventError } = await supabase
      .from("processed_webhook_events")
      .select("event_id")
      .eq("event_id", event.id)
      .maybeSingle();

    if (existingEventError) {
      throw existingEventError;
    }

    if (existingEvent?.event_id) {
      return Response.json(
        { ok: true, deduplicated: true },
        { headers: corsHeaders },
      );
    }

    const { error: insertEventError } = await supabase
      .from("processed_webhook_events")
      .insert({
        event_id: event.id,
        event_type: event.type,
      });

    if (insertEventError) {
      throw insertEventError;
    }

    if (event.type === "payment_intent.succeeded") {
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      const { error: markPaidError } = await supabase.rpc(
        "mark_order_paid_by_payment_intent",
        {
          target_payment_intent_id: paymentIntent.id,
        },
      );

      if (markPaidError) {
        throw markPaidError;
      }

      return Response.json(
        { ok: true, status: "paid" },
        { headers: corsHeaders },
      );
    }

    if (
      event.type === "payment_intent.payment_failed" ||
      event.type === "payment_intent.canceled"
    ) {
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      const { data: order, error: orderError } = await supabase
        .from("orders")
        .select("id")
        .eq("payment_intent_id", paymentIntent.id)
        .maybeSingle();

      if (orderError) {
        throw orderError;
      }

      if (order?.id) {
        const failureStatus = event.type === "payment_intent.canceled"
          ? "cancelled"
          : "payment_failed";
        const { error: failOrderError } = await supabase.rpc(
          "fail_order_payment",
          {
            target_order_id: order.id,
            failure_status: failureStatus,
          },
        );

        if (failOrderError) {
          throw failOrderError;
        }
      }

      return Response.json(
        { ok: true, status: "inventory_released" },
        { headers: corsHeaders },
      );
    }

    return Response.json(
      { ok: true, ignored: event.type },
      { headers: corsHeaders },
    );
  } catch (error) {
    return Response.json(
      {
        error: error instanceof Error ? error.message : "Stripe webhook failed",
      },
      { headers: corsHeaders, status: 400 },
    );
  }
});
