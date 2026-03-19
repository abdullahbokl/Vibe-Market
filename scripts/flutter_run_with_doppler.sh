#!/usr/bin/env bash
set -euo pipefail

if ! command -v doppler >/dev/null 2>&1; then
  echo "doppler CLI is required." >&2
  exit 1
fi

DOPPLER_ARGS=()
FLUTTER_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project|--config|--token|--scope)
      DOPPLER_ARGS+=("$1" "$2")
      shift 2
      ;;
    --)
      shift
      FLUTTER_ARGS+=("$@")
      break
      ;;
    *)
      FLUTTER_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#DOPPLER_ARGS[@]} -eq 0 ]]; then
  DOPPLER_ARGS+=(--project vibemarket --config dev_vibemarket)
fi

doppler run "${DOPPLER_ARGS[@]}" -- bash -s -- "${FLUTTER_ARGS[@]}" <<'EOF'
set -euo pipefail

required_keys=(
  SUPABASE_URL
  SUPABASE_ANON_KEY
)

for key in "${required_keys[@]}"; do
  if [[ -z "${!key:-}" ]]; then
    echo "Missing required Doppler secret: $key" >&2
    exit 1
  fi
done

cat > .dart_defines.generated.json <<JSON
{
  "SUPABASE_URL": "${SUPABASE_URL}",
  "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}",
  "STRIPE_PUBLISHABLE_KEY": "${STRIPE_PUBLISHABLE_KEY:-}",
  "APP_DEEP_LINK_SCHEME": "${APP_DEEP_LINK_SCHEME:-vibemarket}",
  "APP_FLAVOR": "${APP_FLAVOR:-development}",
  "ENABLE_DEMO_MODE": "${ENABLE_DEMO_MODE:-false}"
}
JSON

trap 'rm -f .dart_defines.generated.json' EXIT

flutter run --dart-define-from-file=.dart_defines.generated.json "$@"
EOF
