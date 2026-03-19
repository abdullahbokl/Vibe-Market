create extension if not exists pgcrypto with schema extensions;
create extension if not exists vector with schema extensions;
create extension if not exists pg_net with schema extensions;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null unique,
  display_name text not null,
  avatar_url text,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  tagline text not null,
  description text not null,
  seller_display_name text not null,
  seller_handle text not null,
  price_cents integer not null check (price_cents >= 0),
  currency_code text not null default 'USD',
  hero_image_url text not null,
  sale_end_time timestamptz,
  drop_label text not null,
  tag_list text[] not null default '{}',
  embedding extensions.vector(768),
  sort_rank integer not null default 0,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.product_media (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  media_url text not null,
  media_type text not null default 'image',
  position integer not null default 0
);

create table if not exists public.inventory (
  product_id uuid primary key references public.products (id) on delete cascade,
  available_count integer not null check (available_count >= 0),
  total_count integer not null check (total_count >= 0),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.reactions (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  unique(product_id, user_id)
);

create table if not exists public.wishlists (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  unique(product_id, user_id)
);

create table if not exists public.carts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique(user_id)
);

create table if not exists public.cart_items (
  id uuid primary key default gen_random_uuid(),
  cart_id uuid not null references public.carts (id) on delete cascade,
  product_id uuid not null references public.products (id) on delete cascade,
  quantity integer not null default 1 check (quantity > 0),
  price_cents integer not null check (price_cents >= 0),
  unique(cart_id, product_id)
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  order_status text not null default 'pending_payment',
  idempotency_key text not null unique,
  payment_intent_id text unique,
  subtotal_cents integer not null default 0,
  shipping_cents integer not null default 0,
  total_cents integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  product_id uuid not null references public.products (id),
  quantity integer not null default 1 check (quantity > 0),
  price_cents integer not null check (price_cents >= 0)
);

create table if not exists public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  device_token text not null unique,
  platform text not null,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists products_sale_end_time_idx
  on public.products (sale_end_time desc);

create index if not exists products_sort_rank_idx
  on public.products (sort_rank desc, created_at desc);

create index if not exists products_embedding_idx
  on public.products using ivfflat (embedding vector_cosine_ops)
  with (lists = 100);

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

create or replace function public.notify_paid_order()
returns trigger
language plpgsql
security definer
as $$
declare
  notify_url text := current_setting('app.settings.paid_order_notify_url', true);
begin
  if notify_url is null or notify_url = '' then
    return new;
  end if;

  perform net.http_post(
    url := notify_url,
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object(
      'order_id', new.id,
      'user_id', new.user_id,
      'status', new.order_status
    )
  );

  return new;
end;
$$;

drop trigger if exists orders_paid_notify_trigger on public.orders;
create trigger orders_paid_notify_trigger
after update on public.orders
for each row
when (new.order_status = 'paid' and old.order_status is distinct from new.order_status)
execute function public.notify_paid_order();

alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.product_media enable row level security;
alter table public.inventory enable row level security;
alter table public.reactions enable row level security;
alter table public.wishlists enable row level security;
alter table public.carts enable row level security;
alter table public.cart_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.device_tokens enable row level security;

create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using (auth.uid() = id);

create policy "products_public_read"
on public.products
for select
to anon, authenticated
using (true);

create policy "product_media_public_read"
on public.product_media
for select
to anon, authenticated
using (true);

create policy "inventory_public_read"
on public.inventory
for select
to anon, authenticated
using (true);

create policy "reactions_public_read"
on public.reactions
for select
to anon, authenticated
using (true);

create policy "reactions_insert_own"
on public.reactions
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "reactions_delete_own"
on public.reactions
for delete
to authenticated
using (auth.uid() = user_id);

create policy "wishlists_select_own"
on public.wishlists
for select
to authenticated
using (auth.uid() = user_id);

create policy "wishlists_write_own"
on public.wishlists
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "carts_manage_own"
on public.carts
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "cart_items_manage_own"
on public.cart_items
for all
to authenticated
using (
  exists (
    select 1 from public.carts c
    where c.id = cart_id and c.user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.carts c
    where c.id = cart_id and c.user_id = auth.uid()
  )
);

create policy "orders_select_own"
on public.orders
for select
to authenticated
using (auth.uid() = user_id);

create policy "orders_insert_own"
on public.orders
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "order_items_select_own"
on public.order_items
for select
to authenticated
using (
  exists (
    select 1 from public.orders o
    where o.id = order_id and o.user_id = auth.uid()
  )
);

create policy "device_tokens_manage_own"
on public.device_tokens
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
