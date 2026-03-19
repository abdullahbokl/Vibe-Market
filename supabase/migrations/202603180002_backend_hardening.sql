alter table public.orders
  add column if not exists currency_code text not null default 'USD';

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'orders_status_check'
      and conrelid = 'public.orders'::regclass
  ) then
    alter table public.orders
      add constraint orders_status_check
      check (
        order_status in (
          'pending_payment',
          'paid',
          'payment_failed',
          'cancelled',
          'refunded'
        )
      );
  end if;
end;
$$;

create table if not exists public.processed_webhook_events (
  event_id text primary key,
  event_type text not null,
  processed_at timestamptz not null default timezone('utc', now())
);

alter table public.processed_webhook_events enable row level security;

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists carts_touch_updated_at on public.carts;
create trigger carts_touch_updated_at
before update on public.carts
for each row
execute function public.touch_updated_at();

drop trigger if exists orders_touch_updated_at on public.orders;
create trigger orders_touch_updated_at
before update on public.orders
for each row
execute function public.touch_updated_at();

drop trigger if exists inventory_touch_updated_at on public.inventory;
create trigger inventory_touch_updated_at
before update on public.inventory
for each row
execute function public.touch_updated_at();

create or replace function public.handle_new_user_profile()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  resolved_display_name text;
begin
  resolved_display_name := coalesce(
    new.raw_user_meta_data ->> 'display_name',
    new.raw_user_meta_data ->> 'name',
    split_part(coalesce(new.email, ''), '@', 1),
    'Vibe Member'
  );

  insert into public.profiles (id, email, display_name, avatar_url)
  values (
    new.id,
    coalesce(new.email, ''),
    resolved_display_name,
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do update
  set
    email = excluded.email,
    display_name = excluded.display_name,
    avatar_url = coalesce(excluded.avatar_url, public.profiles.avatar_url);

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user_profile();

create or replace function public.create_checkout_order(
  checkout_user_id uuid,
  checkout_idempotency_key text,
  checkout_items jsonb,
  payment_intent_identifier text default null
)
returns table (
  order_id uuid,
  subtotal_cents integer,
  shipping_cents integer,
  total_cents integer,
  currency_code text,
  order_status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  existing_order public.orders%rowtype;
  checkout_item record;
  checkout_product_id uuid;
  checkout_quantity integer;
  current_price_cents integer;
  current_currency_code text;
  current_sale_end_time timestamptz;
  current_available_count integer;
  computed_subtotal_cents integer := 0;
  computed_shipping_cents integer := 0;
  computed_total_cents integer := 0;
  computed_currency_code text := null;
  created_order_id uuid;
begin
  if checkout_user_id is null then
    raise exception 'checkout_user_id is required.';
  end if;

  if coalesce(trim(checkout_idempotency_key), '') = '' then
    raise exception 'checkout_idempotency_key is required.';
  end if;

  if checkout_items is null
     or jsonb_typeof(checkout_items) <> 'array'
     or jsonb_array_length(checkout_items) = 0 then
    raise exception 'checkout_items must be a non-empty array.';
  end if;

  select *
  into existing_order
  from public.orders
  where user_id = checkout_user_id
    and idempotency_key = checkout_idempotency_key
  limit 1;

  if found then
    return query
    select
      existing_order.id,
      existing_order.subtotal_cents,
      existing_order.shipping_cents,
      existing_order.total_cents,
      existing_order.currency_code,
      existing_order.order_status;
    return;
  end if;

  for checkout_item in
    select value
    from jsonb_array_elements(checkout_items)
  loop
    checkout_product_id := nullif(checkout_item.value ->> 'product_id', '')::uuid;
    checkout_quantity := greatest(
      coalesce((checkout_item.value ->> 'quantity')::integer, 1),
      1
    );

    if checkout_product_id is null then
      raise exception 'Each checkout item must include a valid product_id.';
    end if;

    select
      p.price_cents,
      p.currency_code,
      p.sale_end_time,
      i.available_count
    into
      current_price_cents,
      current_currency_code,
      current_sale_end_time,
      current_available_count
    from public.products p
    join public.inventory i on i.product_id = p.id
    where p.id = checkout_product_id
    for update of i;

    if not found then
      raise exception 'Product % could not be found for checkout.', checkout_product_id;
    end if;

    if current_sale_end_time is not null
       and current_sale_end_time <= timezone('utc', now()) then
      raise exception 'Product % is no longer available for this drop.', checkout_product_id;
    end if;

    if current_available_count < checkout_quantity then
      raise exception 'Product % no longer has enough inventory.', checkout_product_id;
    end if;

    if computed_currency_code is null then
      computed_currency_code := current_currency_code;
    elsif computed_currency_code <> current_currency_code then
      raise exception 'All checkout items must share a single currency.';
    end if;

    computed_subtotal_cents :=
      computed_subtotal_cents + (current_price_cents * checkout_quantity);
  end loop;

  computed_shipping_cents :=
    case
      when computed_subtotal_cents >= 20000 then 0
      else 900
    end;
  computed_total_cents := computed_subtotal_cents + computed_shipping_cents;

  insert into public.orders (
    user_id,
    order_status,
    idempotency_key,
    payment_intent_id,
    subtotal_cents,
    shipping_cents,
    total_cents,
    currency_code
  )
  values (
    checkout_user_id,
    'pending_payment',
    checkout_idempotency_key,
    payment_intent_identifier,
    computed_subtotal_cents,
    computed_shipping_cents,
    computed_total_cents,
    coalesce(computed_currency_code, 'USD')
  )
  returning id into created_order_id;

  for checkout_item in
    select value
    from jsonb_array_elements(checkout_items)
  loop
    checkout_product_id := nullif(checkout_item.value ->> 'product_id', '')::uuid;
    checkout_quantity := greatest(
      coalesce((checkout_item.value ->> 'quantity')::integer, 1),
      1
    );

    select
      p.price_cents,
      p.currency_code,
      p.sale_end_time,
      i.available_count
    into
      current_price_cents,
      current_currency_code,
      current_sale_end_time,
      current_available_count
    from public.products p
    join public.inventory i on i.product_id = p.id
    where p.id = checkout_product_id
    for update of i;

    if not found then
      raise exception 'Product % disappeared while creating the order.', checkout_product_id;
    end if;

    if current_sale_end_time is not null
       and current_sale_end_time <= timezone('utc', now()) then
      raise exception 'Product % expired before the order could be completed.', checkout_product_id;
    end if;

    update public.inventory
    set available_count = available_count - checkout_quantity
    where product_id = checkout_product_id
      and available_count >= checkout_quantity;

    if not found then
      raise exception 'Product % sold out while the order was being created.', checkout_product_id;
    end if;

    insert into public.order_items (
      order_id,
      product_id,
      quantity,
      price_cents
    )
    values (
      created_order_id,
      checkout_product_id,
      checkout_quantity,
      current_price_cents
    );
  end loop;

  return query
  select
    created_order_id,
    computed_subtotal_cents,
    computed_shipping_cents,
    computed_total_cents,
    coalesce(computed_currency_code, 'USD'),
    'pending_payment'::text;
end;
$$;

create or replace function public.fail_order_payment(
  target_order_id uuid,
  failure_status text default 'payment_failed'
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  normalized_failure_status text := lower(trim(coalesce(failure_status, 'payment_failed')));
begin
  if normalized_failure_status not in ('payment_failed', 'cancelled') then
    raise exception 'failure_status must be payment_failed or cancelled.';
  end if;

  update public.orders
  set order_status = normalized_failure_status
  where id = target_order_id
    and order_status = 'pending_payment';

  if not found then
    return false;
  end if;

  update public.inventory i
  set available_count = i.available_count + oi.quantity
  from public.order_items oi
  where oi.order_id = target_order_id
    and oi.product_id = i.product_id;

  return true;
end;
$$;

create or replace function public.mark_order_paid_by_payment_intent(
  target_payment_intent_id text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  paid_order_id uuid;
begin
  update public.orders
  set order_status = 'paid'
  where payment_intent_id = target_payment_intent_id
    and order_status <> 'paid'
  returning id into paid_order_id;

  return paid_order_id;
end;
$$;

create or replace function public.notify_paid_order()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  notify_url text := current_setting('app.settings.paid_order_notify_url', true);
  notify_secret text := current_setting('app.settings.paid_order_notify_secret', true);
  notify_headers jsonb := jsonb_build_object('Content-Type', 'application/json');
begin
  if notify_url is null or notify_url = '' then
    return new;
  end if;

  if notify_secret is not null and notify_secret <> '' then
    notify_headers := notify_headers || jsonb_build_object(
      'x-vibemarket-internal-secret',
      notify_secret
    );
  end if;

  perform net.http_post(
    url := notify_url,
    headers := notify_headers,
    body := jsonb_build_object(
      'order_id', new.id,
      'user_id', new.user_id,
      'payment_intent_id', new.payment_intent_id,
      'status', new.order_status
    )
  );

  return new;
end;
$$;

grant execute
on function public.semantic_search_products(extensions.vector(768), integer)
to anon, authenticated;

revoke all
on function public.create_checkout_order(uuid, text, jsonb, text)
from public, anon, authenticated;

revoke all
on function public.fail_order_payment(uuid, text)
from public, anon, authenticated;

revoke all
on function public.mark_order_paid_by_payment_intent(text)
from public, anon, authenticated;

do $$
begin
  if exists (
    select 1
    from pg_publication
    where pubname = 'supabase_realtime'
  ) and not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'inventory'
  ) then
    execute 'alter publication supabase_realtime add table public.inventory';
  end if;

  if exists (
    select 1
    from pg_publication
    where pubname = 'supabase_realtime'
  ) and not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'orders'
  ) then
    execute 'alter publication supabase_realtime add table public.orders';
  end if;
end;
$$;
