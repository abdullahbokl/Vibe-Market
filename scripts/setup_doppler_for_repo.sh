#!/usr/bin/env bash
set -euo pipefail

if ! command -v doppler >/dev/null 2>&1; then
  echo "doppler CLI is required." >&2
  exit 1
fi

if ! doppler me >/dev/null 2>&1; then
  echo "Doppler login is required first. Run: doppler login" >&2
  exit 1
fi

doppler setup --project vibemarket --config dev_vibemarket --scope . --no-interactive

echo
echo "Doppler is now configured for this repo."
echo "Project: vibemarket"
echo "Config: dev_vibemarket"
echo
echo "Next steps:"
echo "  1. Add any missing secrets to Doppler"
echo "  2. Run Flutter from VS Code with 'VibeMarket Debug/Profile/Release (Doppler)'"
echo "  3. Or run ./scripts/flutter_run_with_doppler.sh"
