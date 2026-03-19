import { createClient } from "https://esm.sh/@supabase/supabase-js@2.57.4";
import { embedText } from "../_shared/embedding_provider.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-vibemarket-admin-secret",
};

type ProductRow = {
  id: string;
  title: string;
  tagline: string;
  description: string;
  seller_display_name: string;
  drop_label: string;
  tag_list: string[] | null;
};

Deno.serve(async (request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const adminSecret = Deno.env.get("EMBEDDING_ADMIN_SECRET") ?? "";
    const providedSecret =
      request.headers.get("x-vibemarket-admin-secret") ?? "";

    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required.");
    }

    if (adminSecret && providedSecret !== adminSecret) {
      return Response.json(
        { error: "Invalid embedding admin secret." },
        { headers: corsHeaders, status: 401 },
      );
    }

    const body = await request.json().catch(() => ({}));
    const limit = Math.min(Math.max(Number(body.limit ?? 25), 1), 100);
    const force = body.force === true;
    const productId = typeof body.product_id === "string"
      ? body.product_id
      : null;

    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false },
    });
    let query = supabase
      .from("products")
      .select(
        "id, title, tagline, description, seller_display_name, drop_label, tag_list",
      )
      .order("created_at", { ascending: false })
      .limit(limit);

    if (!force) {
      query = query.is("embedding", null);
    }

    if (productId) {
      query = query.eq("id", productId);
    }

    const { data: products, error: productsError } = await query;
    if (productsError) {
      throw productsError;
    }

    const rows = (products ?? []) as ProductRow[];
    let updatedCount = 0;

    for (const product of rows) {
      const documentText = [
        product.tagline,
        product.description,
        product.seller_display_name,
        product.drop_label,
        ...(product.tag_list ?? []),
      ]
        .filter((value) => value && value.trim().length > 0)
        .join("\n");
      const embedding = await embedText(
        `title: ${product.title || "none"} | text: ${documentText}`,
      );
      const embeddingVector = `[${embedding.join(",")}]`;

      const { error: updateError } = await supabase
        .from("products")
        .update({
          embedding: embeddingVector,
        })
        .eq("id", product.id);

      if (updateError) {
        throw updateError;
      }

      updatedCount += 1;
    }

    return Response.json(
      {
        ok: true,
        updated_count: updatedCount,
      },
      { headers: corsHeaders },
    );
  } catch (error) {
    return Response.json(
      {
        error: error instanceof Error ? error.message : "Embedding backfill failed",
      },
      { headers: corsHeaders, status: 500 },
    );
  }
});
