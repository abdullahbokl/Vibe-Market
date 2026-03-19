# VibeMarket

VibeMarket is a premium Flutter buyer app for social commerce. The product is
built around vertical discovery, semantic search, limited-time drops, and fast
checkout on top of Supabase.

## What Is Working

- Vertical feed with premium dark styling
- Product detail with live countdown and protected actions
- Guest browsing with auth-gated reactions, wishlist, cart, and checkout
- Email sign in, Google sign in, and email registration
- Semantic search through Supabase Edge Functions and pgvector
- Deterministic fake-embedding fallback for local testing when `HF_TOKEN` is missing
- Supabase-backed test catalog with 27 seeded products

## Project Layout

The Flutter app follows clean architecture:

```text
lib/
  app/
  core/
  features/
    auth/
    bootstrap/
    cart/
    checkout/
    feed/
    orders/
    product/
    search/
    wishlist/
```

Core backend assets live in:

- [supabase/config.toml](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/config.toml)
- [202603180001_initial_schema.sql](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/migrations/202603180001_initial_schema.sql)
- [202603180002_backend_hardening.sql](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/migrations/202603180002_backend_hardening.sql)
- [202603190001_switch_to_embeddinggemma.sql](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/migrations/202603190001_switch_to_embeddinggemma.sql)
- [seed.sql](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/seed.sql)

## Flutter Environment

The app reads runtime configuration from Dart defines in
[app_environment.dart](/home/bokl2002/Abdullah/Work/VibeMarket/lib/core/config/app_environment.dart).

Expected keys:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `STRIPE_PUBLISHABLE_KEY`
- `APP_DEEP_LINK_SCHEME`
- `APP_FLAVOR`
- `ENABLE_DEMO_MODE`

Defaults:

- `APP_DEEP_LINK_SCHEME=vibemarket`
- `APP_FLAVOR=development`
- `ENABLE_DEMO_MODE=true`

## Local Run

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

## Doppler Workflow

This repo is set up to use Doppler by default.

Main files:

- [doppler.yaml](/home/bokl2002/Abdullah/Work/VibeMarket/doppler.yaml)
- [setup_doppler_for_repo.sh](/home/bokl2002/Abdullah/Work/VibeMarket/scripts/setup_doppler_for_repo.sh)
- [generate_dart_defines_with_doppler.sh](/home/bokl2002/Abdullah/Work/VibeMarket/scripts/generate_dart_defines_with_doppler.sh)
- [flutter_run_with_doppler.sh](/home/bokl2002/Abdullah/Work/VibeMarket/scripts/flutter_run_with_doppler.sh)
- [supabase_sync_secrets_with_doppler.sh](/home/bokl2002/Abdullah/Work/VibeMarket/scripts/supabase_sync_secrets_with_doppler.sh)

Default Doppler target:

- project: `vibemarket`
- config: `dev_vibemarket`

New-device setup:

```bash
doppler login
./scripts/setup_doppler_for_repo.sh
```

Run Flutter with Doppler:

```bash
./scripts/flutter_run_with_doppler.sh
```

Generate defines only:

```bash
./scripts/generate_dart_defines_with_doppler.sh
```

Required Doppler secrets for app launch:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Optional for partial development:

- `STRIPE_PUBLISHABLE_KEY`
- `APP_DEEP_LINK_SCHEME`
- `APP_FLAVOR`
- `ENABLE_DEMO_MODE`

## VS Code Launch

VS Code launch configs are already wired to Doppler through
[launch.json](/home/bokl2002/Abdullah/Work/VibeMarket/.vscode/launch.json) and
[tasks.json](/home/bokl2002/Abdullah/Work/VibeMarket/.vscode/tasks.json).

Available launches:

- `VibeMarket Debug (Doppler)`
- `VibeMarket Profile (Doppler)`
- `VibeMarket Release (Doppler)`

All of them generate `.dart_defines.generated.json` before launching.

## Live Supabase Project

Current live test project:

- project ref: `hebrlpywruokkobtyjvi`
- URL: `https://hebrlpywruokkobtyjvi.supabase.co`

This project already has:

- migrations applied
- Edge Functions deployed
- 27 seeded products
- embeddings backfilled

## Supabase Secrets

Expected backend secrets:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `HF_TOKEN`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `PAID_ORDER_NOTIFY_SECRET`
- `EMBEDDING_ADMIN_SECRET`

`HF_TOKEN` is optional for semantic-search testing. If it is missing, the
embedding functions use deterministic fake embeddings from
[embedding_provider.ts](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/functions/_shared/embedding_provider.ts).

Sync Doppler secrets into the live Supabase project:

```bash
./scripts/supabase_sync_secrets_with_doppler.sh hebrlpywruokkobtyjvi
```

## Edge Functions

Current backend functions:

- [semantic-search/index.ts](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/functions/semantic-search/index.ts)
- [backfill-product-embeddings/index.ts](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/functions/backfill-product-embeddings/index.ts)
- [create-checkout-intent/index.ts](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/functions/create-checkout-intent/index.ts)
- [stripe-webhook/index.ts](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/functions/stripe-webhook/index.ts)
- [paid-order-notify/index.ts](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/functions/paid-order-notify/index.ts)

Semantic-search notes:

- Uses `google/embeddinggemma-300m`
- Stores `vector(768)` embeddings
- Falls back to deterministic test embeddings when `HF_TOKEN` is not present

If you are migrating from the old OpenAI embedding pipeline, the migration in
[202603190001_switch_to_embeddinggemma.sql](/home/bokl2002/Abdullah/Work/VibeMarket/supabase/migrations/202603190001_switch_to_embeddinggemma.sql)
resets previous vectors so they can be regenerated at the new dimension.

Refresh embeddings manually:

```bash
curl -X POST \
  "https://hebrlpywruokkobtyjvi.supabase.co/functions/v1/backfill-product-embeddings" \
  -H "Content-Type: application/json" \
  -d '{"limit": 100, "force": true}'
```

If `EMBEDDING_ADMIN_SECRET` is configured, include:

```bash
-H "x-vibemarket-admin-secret: YOUR_EMBEDDING_ADMIN_SECRET"
```

## Auth

The auth flow currently supports:

- email sign in
- email registration
- Google sign in
- continue as guest

Relevant files:

- [supabase_auth_repository.dart](/home/bokl2002/Abdullah/Work/VibeMarket/lib/features/auth/data/repositories/supabase_auth_repository.dart)
- [auth_cubit.dart](/home/bokl2002/Abdullah/Work/VibeMarket/lib/features/auth/presentation/cubit/auth_cubit.dart)
- [sign_in_page.dart](/home/bokl2002/Abdullah/Work/VibeMarket/lib/features/auth/presentation/pages/sign_in_page.dart)

If Supabase email confirmation is enabled, registration may create the account
without immediately authenticating the session. The UI already handles that and
shows a status message.

## Catalog for Semantic Search Testing

The test catalog now includes 27 products across fashion, audio, travel,
workspace, sea, marriage, and laptop categories.

Useful query checks:

- `night running jacket`
- `coffee barista setup`
- `camera creator bag`
- `sea jacket for sailing`
- `beach tote for weekend`
- `wedding ceremony blazer`
- `formal dress for marriage`
- `laptop desk setup`
- `portable monitor for travel work`
- `charger for laptop travel`

Expected examples:

- `night running jacket` should rank `Obsidian Runner Jacket` first
- `coffee barista setup` should rank `Atlas Pour-Over Set` and `Onyx Espresso Grinder` near the top
- `camera creator bag` should rank `Meridian Camera Sling` first

## Product Detail Note

Search results now open correctly in product detail even when the product came
from live Supabase data. That behavior is handled by
[hybrid_product_repository.dart](/home/bokl2002/Abdullah/Work/VibeMarket/lib/features/product/data/repositories/hybrid_product_repository.dart),
which loads live product UUIDs and falls back to local seed data when needed.

## Verification

Recommended checks after changes:

```bash
flutter analyze
flutter test
```

Those commands are currently passing in this repo.
