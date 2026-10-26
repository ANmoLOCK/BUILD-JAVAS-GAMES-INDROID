#!/usr/bin/env bash
# Roda todos os testes headless do cérebro (requer godot4 no PATH).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GODOT="${GODOT:-godot4}"
if ! command -v "$GODOT" >/dev/null 2>&1; then
  GODOT="godot"
fi
if ! command -v "$GODOT" >/dev/null 2>&1; then
  echo "Godot não encontrado (defina GODOT=...). Validando só o pack Python."
  python3 "$ROOT/../../tools/validate_content.py" "$ROOT/content" --lite
  python3 "$ROOT/tools/validate_assets.py"
  exit 0
fi

fail=0
for script in \
  test_content_registry.gd \
  test_stats.gd \
  test_economy.gd \
  test_asset_registry.gd \
  test_interactions.gd \
  text_day.gd
do
  echo "=== $script ==="
  if ! "$GODOT" --path "$ROOT" --headless -s "res://tests/$script"; then
    echo "FAIL $script"
    fail=1
  fi
done
exit $fail
