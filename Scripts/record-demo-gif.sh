#!/usr/bin/env bash
# Record the native iOS Demo capture screen from a booted Simulator.
# Before running: open the Demo, select "Minimal grid / GIF capture", then "Capture GIF".
set -euo pipefail
cd "$(dirname "$0")/.."
command -v xcrun >/dev/null || { echo 'Requires macOS and Xcode (xcrun).' >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo 'Install ffmpeg first: brew install ffmpeg' >&2; exit 1; }
DURATION="${DURATION:-8}"
FPS="${FPS:-15}"
WIDTH="${WIDTH:-640}"
OUTPUT="${1:-Media/MonoLoadKit-44-styles.gif}"
mkdir -p "$(dirname "$OUTPUT")"
TEMP_VIDEO="$(mktemp -t monoloadkit-video).mp4"
trap 'rm -f "$TEMP_VIDEO"' EXIT
if ! xcrun simctl list devices booted | grep -q '(Booted)'; then
    echo 'Boot an iOS Simulator before recording.' >&2
    exit 1
fi
echo 'Recording the booted Simulator for' "$DURATION" 'seconds...'
echo 'Open the Demo capture view first (double-tap to exit it afterward).'
xcrun simctl io booted recordVideo --codec=h264 "$TEMP_VIDEO" &
PID=$!
sleep "$DURATION"
kill -INT "$PID" 2>/dev/null || true
wait "$PID" || true
if [[ ! -s "$TEMP_VIDEO" ]]; then
    echo 'No simulator video captured; check the simulator and simctl output.' >&2
    exit 1
fi
# Palette-based encoding prevents poor gray gradients in typical GIF encoders.
ffmpeg -hide_banner -loglevel error -y -i "$TEMP_VIDEO" \
    -filter_complex "[0:v]fps=${FPS},scale=${WIDTH}:-2:flags=lanczos,split[a][b];[a]palettegen=stats_mode=full[p];[b][p]paletteuse=dither=bayer:bayer_scale=3[out]" \
    -map '[out]' -loop 0 "$OUTPUT"
echo "GIF saved to: $OUTPUT"
echo 'Add the file to your repo, then embed it in README.md.'
