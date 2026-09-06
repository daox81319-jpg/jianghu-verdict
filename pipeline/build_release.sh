#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
GAME="$ROOT/game"
DIST="$ROOT/dist"
ZIP="$DIST/JianghuVerdict.zip"
RELEASE_DIR="$DIST/release"
APP="$RELEASE_DIR/江湖裁决.app"

rm -rf "$RELEASE_DIR" "$ZIP"
mkdir -p "$DIST" "$RELEASE_DIR"
godot --headless --path "$GAME" --export-release macOS "$ZIP"
ditto -x -k "$ZIP" "$RELEASE_DIR"

EXPORTED_APP="$(find "$RELEASE_DIR" -maxdepth 1 -type d -name '*.app' -print -quit)"
if [ "$EXPORTED_APP" != "$APP" ]; then
	mv "$EXPORTED_APP" "$APP"
fi
codesign --force --deep --sign - "$APP"
codesign --verify --deep --strict "$APP"
echo "Built release app: $APP"
