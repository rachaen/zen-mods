#!/usr/bin/env zsh
# Turn a screenshot into the 600x400 PNG the theme-store bot requires.
# Usage: ./make-image.sh <screenshot.png> [output.png]
# Scales the shorter side to fit, then center-crops to exactly 600x400 (macOS sips only).
set -euo pipefail
SRC="${1:?usage: make-image.sh <screenshot.png> [output.png]}"
OUT="${2:-$(dirname "$0")/image.png}"
TMP="$(mktemp -d)/scaled.png"
W=$(sips -g pixelWidth  "$SRC" | awk '/pixelWidth/{print $2}')
H=$(sips -g pixelHeight "$SRC" | awk '/pixelHeight/{print $2}')
# Scale so that both dimensions are >= target while keeping aspect ratio.
if (( W * 400 > H * 600 )); then
  sips -s format png --resampleHeight 400 "$SRC" --out "$TMP" >/dev/null
else
  sips -s format png --resampleWidth 600 "$SRC" --out "$TMP" >/dev/null
fi
sips -c 400 600 "$TMP" --out "$OUT" >/dev/null
echo "wrote $OUT: $(sips -g pixelWidth -g pixelHeight "$OUT" | awk '/pixel/{printf "%s ", $2}')"
