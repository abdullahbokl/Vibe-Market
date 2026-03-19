#!/usr/bin/env bash
set -euo pipefail

if ! command -v doppler >/dev/null 2>&1; then
  echo "doppler CLI is required." >&2
  exit 1
fi

project_ref="${1:-}"
if [[ -z "$project_ref" ]]; then
  echo "Usage: $0 <supabase-project-ref> [doppler args...]" >&2
  exit 1
fi
shift

DOPPLER_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project|--config|--token|--scope)
      DOPPLER_ARGS+=("$1" "$2")
      shift 2
      ;;
    *)
      echo "Unsupported argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ ${#DOPPLER_ARGS[@]} -eq 0 ]]; then
  DOPPLER_ARGS+=(--project vibemarket --config dev_vibemarket)
fi

doppler run "${DOPPLER_ARGS[@]}" -- bash -s -- "$project_ref" <<'EOF'
set -euo pipefail

project_ref="$1"

required_keys=(
  STRIPE_SECRET_KEY
  STRIPE_WEBHOOK_SECRET
  PAID_ORDER_NOTIFY_SECRET
  EMBEDDING_ADMIN_SECRET
)

for key in "${required_keys[@]}"; do
  if [[ -z "${!key:-}" ]]; then
    echo "Missing required Doppler secret: $key" >&2
    exit 1
  fi
done

npx --yes supabase link --project-ref "$project_ref" >/dev/null
secret_args=(
  STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY"
  STRIPE_WEBHOOK_SECRET="$STRIPE_WEBHOOK_SECRET"
  PAID_ORDER_NOTIFY_SECRET="$PAID_ORDER_NOTIFY_SECRET"
  EMBEDDING_ADMIN_SECRET="$EMBEDDING_ADMIN_SECRET"
)

if [[ -n "${HF_TOKEN:-}" ]]; then
  secret_args+=(HF_TOKEN="$HF_TOKEN")
fi

npx --yes supabase secrets set "${secret_args[@]}"
EOF
