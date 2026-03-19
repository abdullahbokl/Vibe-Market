alter table public.products
  alter column sale_end_time drop not null;

create or replace function public.semantic_search_products(
  query_embedding extensions.vector(768),
  match_count integer default 12
)
returns table (
  id uuid,
  title text,
  tagline text,
  price_cents integer,
  currency_code text,
  hero_image_url text,
  seller_display_name text,
  seller_handle text,
  available_count integer,
  total_count integer,
  is_low_stock boolean,
  sale_end_time timestamptz,
  drop_label text,
  tag_list text[],
  reaction_count bigint,
  live_viewer_count integer,
  similarity double precision
)
language sql
stable
set search_path = public, extensions
as $$
  select
    p.id,
    p.title,
    p.tagline,
    p.price_cents,
    p.currency_code,
    p.hero_image_url,
    p.seller_display_name,
    p.seller_handle,
    i.available_count,
    i.total_count,
    i.available_count <= 15 as is_low_stock,
    p.sale_end_time,
    p.drop_label,
    p.tag_list,
    count(r.id) as reaction_count,
    greatest(20, least(350, count(r.id)::integer + i.available_count)) as live_viewer_count,
    1 - (p.embedding <=> query_embedding) as similarity
  from public.products p
  join public.inventory i on i.product_id = p.id
  left join public.reactions r on r.product_id = p.id
  where p.embedding is not null
  group by p.id, i.product_id
  order by p.embedding <=> query_embedding
  limit match_count;
$$;

update public.products
set sale_end_time = null
where slug not in (
  'obsidian-runner-jacket',
  'pulse-audio-case',
  'tidebreaker-sailing-shell',
  'midnight-ceremony-blazer',
  'vector-portable-monitor'
);
