import { createClient } from "https://esm.sh/@supabase/supabase-js@2.57.4";
import { embedText } from "../_shared/embedding_provider.ts";

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
    const body = await request.json();
    const query = String(body.query ?? "").trim();

    if (!query) {
      return Response.json({ items: [] }, { headers: corsHeaders });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required.");
    }

    const embedding = await embedText(`task: search result | query: ${query}`);
    const embeddingVector = `[${embedding.join(",")}]`;

    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false },
    });

    const { data, error } = await supabase.rpc("semantic_search_products", {
      query_embedding: embeddingVector,
      match_count: 12,
    });

    if (error) {
      throw error;
    }

    const items = (data ?? []).map((item: Record<string, unknown>) => ({
      id: item.id,
      title: item.title,
      tagline: item.tagline,
      priceCents: item.price_cents,
      currencyCode: item.currency_code,
      heroImageUrl: item.hero_image_url,
      seller: {
        id: String(item.id),
        handle: item.seller_handle,
        displayName: item.seller_display_name,
      },
      inventory: {
        availableCount: item.available_count,
        totalCount: item.total_count,
        isLowStock: item.is_low_stock,
      },
      dropMetadata: {
        saleEndTime: item.sale_end_time ?? null,
        dropLabel: item.drop_label,
      },
      reactionSnapshot: {
        reactionCount: item.reaction_count,
        liveViewerCount: item.live_viewer_count,
        hasReacted: false,
      },
      tags: item.tag_list ?? [],
      similarity: item.similarity,
    }));

    return Response.json({ items }, { headers: corsHeaders });
  } catch (error) {
    return Response.json(
      {
        error: error instanceof Error ? error.message : "Unknown search error",
      },
      { headers: corsHeaders, status: 500 },
    );
  }
});
