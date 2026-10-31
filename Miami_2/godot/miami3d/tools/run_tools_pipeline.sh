#!/usr/bin/env bash
# Atalhos da etapa tools/ a partir de miami3d/.
set -euo pipefail
MIAMI3D="$(cd "$(dirname "$0")/.." && pwd)"
MIAMI2="$(cd "$MIAMI3D/../.." && pwd)"
TOOLS="$MIAMI2/tools"

cmd="${1:-help}"
shift || true

case "$cmd" in
  extract)
    exec python3 "$TOOLS/mn2_extract_all.py" "$@"
    ;;
  validate)
    exec python3 "$TOOLS/validate_content.py" "$MIAMI3D/content" --lite "$@"
    ;;
  validate-full)
    exec python3 "$TOOLS/validate_content.py" "$MIAMI3D/content" "$@"
    ;;
  validate-assets)
    exec python3 "$MIAMI3D/tools/validate_assets.py"
    ;;
  rooms)
    exec python3 "$TOOLS/room_to_godot.py" "$MIAMI2/07-salas" --all "$@"
    ;;
  preview)
    exec python3 "$TOOLS/appearance_preview.py" "$@"
    ;;
  gallery)
    mkdir -p "$MIAMI3D/assets/ui/previews"
    exec python3 "$TOOLS/appearance_preview.py" --gallery -o "$MIAMI3D/assets/ui/previews"
    ;;
  test)
    exec bash "$MIAMI3D/tests/run_all.sh"
    ;;
  help|*)
    cat <<EOF
Uso: $(basename "$0") <comando>

  extract ...       mn2_extract_all.py (JAR → pastas 00–08)
  validate          validate_content.py --lite no pack miami3d
  validate-full     validate_content.py (+ schemas se jsonschema instalado)
  validate-assets   validate_assets.py
  rooms             room_to_godot.py --all (07-salas → placeholders)
  preview ...       appearance_preview.py
  gallery           previews PNG do elenco → assets/ui/previews/
  test              tests/run_all.sh (godot4 headless ou fallback Python)
EOF
    ;;
esac
