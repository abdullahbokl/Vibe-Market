# VibeMarket

VibeMarket is a premium Flutter buyer app for social commerce. The project is
designed to demonstrate strong product thinking and backend engineering around:

- vertical discovery
- semantic search
- flash-sale and standard catalog products
- protected commerce flows
- Supabase-first backend architecture

This repository is intentionally portfolio-grade. It shows how I structure a
Flutter client and a Supabase backend together, with clean architecture on the
app side and security-focused database design on the backend side.

## What This Project Demonstrates

- Flutter clean architecture with DI, Cubit/BLoC, reusable UI, and typed routing
- Supabase Auth with guest browsing plus protected user actions
- PostgreSQL schema design for catalog, inventory, cart, wishlist, and orders
- Row Level Security on every user-sensitive table
- pgvector-based semantic search behind an Edge Function
- Realtime-ready inventory and order streams through Supabase Realtime CDC
- Stripe checkout orchestration with idempotency and webhook reconciliation
- Postgres trigger to server-side notify downstream systems when an order becomes paid

## High-Level Architecture

### Flutter client

The app is structured under `lib/app`, `lib/core`, and `lib/features`.

Key client responsibilities:

- browse products as guest or authenticated user
- call Supabase Auth and Edge Functions
- render feed, semantic search, cart, checkout, and orders
- enforce auth-gated behavior in presentation flows
- persist some local device state such as theme and local cache

### Supabase backend

The backend is versioned inside `supabase/` and includes:

- SQL migrations
- seed data
- Edge Functions
- local Supabase config

Important backend files:

- `supabase/config.toml`
- `supabase/migrations/202603180001_initial_schema.sql`
- `supabase/migrations/202603180002_backend_hardening.sql`
- `supabase/migrations/202603190001_switch_to_embeddinggemma.sql`
- `supabase/migrations/202603190002_optional_sale_end_time.sql`
- `supabase/migrations/202603190003_add_clothing_catalog.sql`
- `supabase/seed.sql`

## Supabase Deep Dive

### Database design

The database is designed around a marketplace buyer flow, not just a demo auth
table plus products table.

Core entities:

- `profiles`
- `products`
- `product_media`
- `inventory`
- `reactions`
- `wishlists`
- `carts`
- `cart_items`
- `orders`
- `order_items`
- `device_tokens`
- `processed_webhook_events`

Why this matters:

- product content is separated from inventory and media
- user-owned tables are isolated cleanly for RLS
- checkout/order data is modeled explicitly instead of inferred from payment metadata
- webhook deduplication is persisted in SQL, not just handled in app memory

### Catalog model

`products` stores the buyer-facing catalog metadata:

- slug
- title
- tagline
- description
- seller display data
- price and currency
- hero image
- optional `sale_end_time`
- drop label
- tags
- embedding vector
- sort rank

This lets the project support both:

- normal shopping products with no timer
- timed drop products with expiration behavior

That distinction is important because the product model is not hard-coded around
flash sales only.

### Inventory model

Inventory is normalized into `inventory` rather than stored directly on
`products`.

That gives a cleaner split between:

- content and discovery fields
- operational stock state

It also makes realtime stock updates and checkout reservation logic much easier
to reason about.

## Row Level Security

### RLS coverage

RLS is enabled on all important public tables:

- `profiles`
- `products`
- `product_media`
- `inventory`
- `reactions`
- `wishlists`
- `carts`
- `cart_items`
- `orders`
- `order_items`
- `device_tokens`
- `processed_webhook_events`

### Policy strategy

The policy model is intentionally mixed based on domain needs.

Public read policies:

- `products`
- `product_media`
- `inventory`
- `reactions`

These are readable by `anon` and `authenticated` because guest browsing is a
core requirement.

Owner-scoped policies:

- `profiles`
- `wishlists`
- `carts`
- `cart_items`
- `orders`
- `order_items`
- `device_tokens`

These use `auth.uid()` checks directly or through ownership joins. For example:

- `cart_items` checks that the related cart belongs to the current user
- `order_items` checks that the parent order belongs to the current user

This is a strong pattern because it secures child tables through parent
ownership, which is much safer than trusting client-provided IDs.

### Security-definer boundaries

Sensitive SQL routines are protected with `security definer` and direct grants
are revoked where appropriate. This is used for privileged server-side
operations such as:

- checkout order creation
- payment failure rollback
- marking an order as paid from a payment intent
- internal order notification triggers

This is important because the mobile client should never be allowed to mutate
payment-critical state directly.

## Supabase Realtime

### Current usage

Supabase Realtime is enabled in `supabase/config.toml`.

The database hardening migration explicitly publishes these tables to the
`supabase_realtime` publication:

- `inventory`
- `orders`

That means the backend is set up for CDC-based realtime updates for:

- stock changes
- order status changes

This is the right choice for durable business state because inventory and orders
should be sourced from the database, not from ephemeral frontend events.

### Broadcast vs CDC

The project rules distinguish two realtime classes:

- Broadcast for ephemeral interaction signals
- CDC for durable operational data

In the current repo, CDC is implemented and wired at the database level for
inventory and orders. Broadcast is part of the intended architecture for
viewer/reaction-style transient social signals, but there is not yet a
dedicated backend broadcast channel implementation committed here. That’s an
intentional distinction worth calling out because it shows awareness of
realtime consistency tradeoffs rather than lumping all realtime into one tool.

## Semantic Search and pgvector

### Search pipeline

The semantic search flow is:

1. user enters a natural-language query in Flutter
2. app calls the `semantic-search` Edge Function
3. Edge Function generates an embedding
4. Postgres executes `semantic_search_products(...)`
5. ranked products are returned to the client

### Embedding model

The current backend is configured around:

- `google/embeddinggemma-300m`

The project originally targeted OpenAI embeddings at the architecture level,
but the live implementation in this repo was migrated to Hugging Face to keep
testing practical and cost-aware.

### Vector indexing

The `products.embedding` column uses:

- `extensions.vector(768)`

and the search index uses:

- `ivfflat`
- `vector_cosine_ops`

This is a meaningful advanced topic because it shows:

- awareness of embedding dimensionality
- explicit index strategy for approximate nearest neighbor search
- cosine similarity ranking directly in SQL

### Search function design

`semantic_search_products(...)` returns not just product text fields, but also:

- inventory counts
- low-stock derived state
- reaction count
- synthetic live viewer count
- similarity score

So the DB function is shaped for UI consumption rather than returning raw rows
that force the client to re-join everything itself.

### Local testability

The semantic-search backend also supports a deterministic fake-embedding
fallback when `HF_TOKEN` is not present. That is a useful engineering detail
because it lets the search flow remain testable without fully blocking local
development on paid or rate-limited external inference.

## Auth and Profile Bootstrapping

Supabase Auth supports:

- email sign in
- email registration
- Google sign in
- guest continuation on the client side

There is also a server-side profile bootstrap trigger:

- `handle_new_user_profile()`
- trigger on `auth.users`

This automatically creates or updates `public.profiles` when a user is created.

That is a strong backend pattern because:

- the client does not need to manually race profile creation
- user metadata normalization happens centrally
- auth onboarding stays resilient if multiple clients are added later

## Checkout, Stripe, and Payment Safety

### Checkout orchestration

Checkout is not handled by trusting client-side prices.

The secure flow is:

1. client sends product intent to `create-checkout-intent`
2. backend revalidates product, currency, timer state, and stock
3. SQL function creates a pending order using an idempotency key
4. inventory is decremented inside the DB transaction
5. Stripe payment intent is created
6. webhook or server confirmation finalizes payment outcome

### Advanced payment protections

The backend includes several advanced patterns:

- idempotency key on `orders`
- `FOR UPDATE` locking when validating inventory
- rollback path through `fail_order_payment(...)`
- order completion through `mark_order_paid_by_payment_intent(...)`
- webhook dedupe through `processed_webhook_events`

This is not just “Stripe checkout works.” It shows careful thinking about race
conditions and duplicate events.

### Postgres trigger to downstream systems

When an order becomes `paid`, a database trigger calls `notify_paid_order()`,
which uses `pg_net` to send an internal HTTP request to the `paid-order-notify`
Edge Function.

This demonstrates:

- database-triggered backend automation
- internal secret handling for trusted server-to-server traffic
- decoupling warehouse/user notification side effects from client actions

## Edge Functions

Current committed Edge Functions:

- `semantic-search`
- `backfill-product-embeddings`
- `create-checkout-intent`
- `stripe-webhook`
- `paid-order-notify`

### JWT verification strategy

The function configuration is intentionally mixed:

- `create-checkout-intent`: `verify_jwt = true`
- `semantic-search`: `verify_jwt = false`
- `stripe-webhook`: `verify_jwt = false`
- `paid-order-notify`: `verify_jwt = false`
- `backfill-product-embeddings`: `verify_jwt = false`

This reflects actual use cases:

- guest search should remain available
- Stripe webhooks cannot present Supabase JWTs
- internal notify/admin-style functions rely on shared secrets instead

That separation is important from a security-design perspective.

## Live Supabase Project

Current live test project:

- project ref: `hebrlpywruokkobtyjvi`
- URL: `https://hebrlpywruokkobtyjvi.supabase.co`

The live project already has:

- migrations applied
- Edge Functions deployed
- catalog seed data loaded
- embeddings backfilled

## Secrets and Environment Boundaries

Expected backend secrets:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `HF_TOKEN`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `PAID_ORDER_NOTIFY_SECRET`
- `EMBEDDING_ADMIN_SECRET`

Security boundary summary:

- Flutter client gets only public/mobile-safe values
- service-role access stays server-side
- Stripe secret key stays server-side
- internal notify and embedding admin flows use dedicated secrets

This separation is one of the strongest things to show in a portfolio backend.

## Local Development

### Flutter environment

The app reads runtime configuration from Dart defines in
`lib/core/config/app_environment.dart`.

Expected client keys:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `STRIPE_PUBLISHABLE_KEY`
- `APP_DEEP_LINK_SCHEME`
- `APP_FLAVOR`
- `ENABLE_DEMO_MODE`

Run in demo mode:

```bash
flutter run
```

Run against Supabase manually:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://hebrlpywruokkobtyjvi.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY \
  --dart-define=STRIPE_PUBLISHABLE_KEY=YOUR_STRIPE_PUBLISHABLE_KEY \
  --dart-define=ENABLE_DEMO_MODE=false
```

### Doppler workflow

The repo is wired for Doppler-based secret management.

Main files:

- `doppler.yaml`
- `scripts/setup_doppler_for_repo.sh`
- `scripts/generate_dart_defines_with_doppler.sh`
- `scripts/flutter_run_with_doppler.sh`
- `scripts/supabase_sync_secrets_with_doppler.sh`

New-device setup:

```bash
doppler login
./scripts/setup_doppler_for_repo.sh
```

Run Flutter with Doppler:

```bash
./scripts/flutter_run_with_doppler.sh
```

Sync Doppler secrets into the live Supabase project:

```bash
./scripts/supabase_sync_secrets_with_doppler.sh hebrlpywruokkobtyjvi
```

### VS Code launch

VS Code launch configs are already connected to Doppler through:

- `.vscode/launch.json`
- `.vscode/tasks.json`

Available launch profiles:

- `VibeMarket Debug (Doppler)`
- `VibeMarket Profile (Doppler)`
- `VibeMarket Release (Doppler)`

## Catalog for Semantic Search Testing

The seeded catalog spans fashion, audio, travel, workspace, sea, marriage,
laptop, and expanded clothing categories.

Useful semantic checks:

- `night running jacket`
- `coffee barista setup`
- `camera creator bag`
- `sea jacket for sailing`
- `wedding ceremony blazer`
- `laptop desk setup`
- `portable monitor for travel work`

Examples:

- `night running jacket` should rank `Obsidian Runner Jacket` first
- `camera creator bag` should rank `Meridian Camera Sling` first
- `coffee barista setup` should surface coffee workflow products near the top

## Verification

Recommended checks:

```bash
flutter analyze
flutter test
```

These are currently passing in this repo.
