#!/usr/bin/env bash
# Copia o pacote WorldStreamer para o projeto Godot (res://).
set -euo pipefail
PKG="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$(cd "$PKG/../godot/miami3d" && pwd)"

mkdir -p "$DEST/game/world/streamer" "$DEST/content/world_streamer" "$DEST/tests"

cp -f "$PKG/content/world_map.json" "$DEST/content/world_streamer/world_map.json"
cp -f "$PKG/godot/"*.gd "$DEST/game/world/streamer/"

# Teste headless espelho
if [[ -f "$PKG/tests/test_world_streamer.gd" ]]; then
  cp -f "$PKG/tests/test_world_streamer.gd" "$DEST/tests/test_world_streamer.gd"
fi

echo "Installed WorldStreamer →"
echo "  $DEST/game/world/streamer/"
echo "  $DEST/content/world_streamer/world_map.json"
