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
    const expectedInternalSecret = Deno.env.get("PAID_ORDER_NOTIFY_SECRET") ?? "";
    const providedInternalSecret =
      request.headers.get("x-vibemarket-internal-secret") ?? "";

    if (
      expectedInternalSecret &&
      providedInternalSecret !== expectedInternalSecret
    ) {
      return Response.json(
        { error: "Invalid internal notification secret." },
        { headers: corsHeaders, status: 401 },
      );
    }

    const body = await request.json();
    const orderId = String(body.order_id ?? "");
    const userId = String(body.user_id ?? "");
    const status = String(body.status ?? "");

    if (!orderId || !userId || !status) {
      throw new Error("order_id, user_id, and status are required.");
    }

    let deviceTokenCount = 0;
    let itemCount = 0;

    if (supabaseUrl && serviceRoleKey) {
      const supabase = createClient(supabaseUrl, serviceRoleKey, {
        auth: { persistSession: false },
      });

      const [
        { count: tokensCount, error: tokensError },
        { count: orderItemCount, error: orderItemsError },
      ] = await Promise.all([
        supabase
          .from("device_tokens")
          .select("id", { count: "exact", head: true })
          .eq("user_id", userId),
        supabase
          .from("order_items")
          .select("id", { count: "exact", head: true })
          .eq("order_id", orderId),
      ]);

      if (tokensError) {
        throw tokensError;
      }
      if (orderItemsError) {
        throw orderItemsError;
      }

      deviceTokenCount = tokensCount ?? 0;
      itemCount = orderItemCount ?? 0;
    }

    return Response.json(
      {
        ok: true,
        warehouse_notification: {
          order_id: orderId,
          status,
          item_count: itemCount,
        },
        user_notification: {
          user_id: userId,
          order_id: orderId,
          message: "Your VibeMarket order is confirmed and headed to fulfillment.",
          device_token_count: deviceTokenCount,
        },
      },
      { headers: corsHeaders },
    );
  } catch (error) {
    return Response.json(
      {
        error: error instanceof Error ? error.message : "Paid order notify failed",
      },
      { headers: corsHeaders, status: 500 },
    );
  }
});
