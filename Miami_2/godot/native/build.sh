#!/usr/bin/env bash
# Compila o cérebro C++ (GDExtension) para Godot 4.3
set -euo pipefail
cd "$(dirname "$0")"
export PATH="${HOME}/.local/bin:${PATH}"

TARGET="${1:-debug}"          # debug | release
PLATFORM="${2:-linux}"        # linux | android
JOBS="${JOBS:-$(nproc)}"

if [[ ! -d godot-cpp/.git ]]; then
  echo "==> clonando godot-cpp (godot-4.3-stable)…"
  git clone --depth 1 --branch godot-4.3-stable https://github.com/godotengine/godot-cpp.git
fi

if ! command -v scons >/dev/null; then
  pip install --user scons
fi

GODOT_TARGET="template_${TARGET}"
echo "==> scons target=${GODOT_TARGET} platform=${PLATFORM} -j${JOBS}"

case "${PLATFORM}" in
  linux)
    scons target="${GODOT_TARGET}" platform=linux arch=x86_64 -j"${JOBS}"
    ;;
  android)
    # Requer ANDROID_NDK_ROOT
    scons target="${GODOT_TARGET}" platform=android arch=arm64 -j"${JOBS}"
    ;;
  *)
    echo "plataforma desconhecida: ${PLATFORM} (use linux|android)"; exit 1
    ;;
esac

echo "==> artefatos:"
ls -la bin/ || true
ls -la ../miami3d/bin/*.so 2>/dev/null || ls -la ../miami3d/bin/ || true
echo "OK — abra miami3d/ no Godot 4.3+"
