#!/usr/bin/env bash
# Exporta Miami Life APK (Godot 4.3 + Android SDK).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$ROOT/miami3d"
OUT_DIR="$ROOT/releases/android"
GODOT="${GODOT:-$HOME/tools/godot/godot4}"
ANDROID_HOME="${ANDROID_HOME:-$HOME/tools/android-sdk}"
KEYSTORE="${KEYSTORE:-$HOME/tools/miami-debug.keystore}"
JAVA_HOME="${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(which java)")")")}"

export ANDROID_HOME ANDROID_SDK_ROOT="$ANDROID_HOME" JAVA_HOME
export PATH="$HOME/tools/godot:$ANDROID_HOME/platform-tools:$PATH"

mkdir -p "$OUT_DIR"
APK="$OUT_DIR/MiamiLife-0.7.1-debug.apk"

if [[ ! -x "$GODOT" ]]; then
  echo "Godot não encontrado em $GODOT"
  exit 1
fi
if [[ ! -d "$ANDROID_HOME/platforms" ]]; then
  echo "Android SDK incompleto em $ANDROID_HOME"
  exit 1
fi
if [[ ! -f "$KEYSTORE" ]]; then
  keytool -genkeypair -v -keystore "$KEYSTORE" -alias androiddebugkey \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass android -keypass android \
    -dname "CN=HueHueGames, OU=MiamiLife, O=HueHueGames, L=SaoPaulo, ST=SP, C=BR"
fi

mkdir -p "$HOME/.config/godot"
cat > "$HOME/.config/godot/editor_settings-4.3.tres" <<EOF
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/android_sdk_path = "$ANDROID_HOME"
export/android/java_sdk_path = "$JAVA_HOME"
export/android/debug_keystore = "$KEYSTORE"
export/android/debug_keystore_user = "androiddebugkey"
export/android/debug_keystore_pass = "android"
EOF

echo "==> Importando projeto (primeira vez)…"
"$GODOT" --headless --path "$PROJECT" --import || true

echo "==> Exportando APK debug → $APK"
"$GODOT" --headless --path "$PROJECT" --export-debug "Android" "$APK"

ls -lh "$APK"
file "$APK"
echo "OK APK pronto: $APK"
