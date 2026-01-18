#!/bin/bash
# Generate brown noise audio file optimized for deep, low-frequency playback
# Requirements: sox, ffmpeg
#   brew install sox ffmpeg

set -e

OUTPUT_DIR="${1:-.}"
DURATION="${2:-600}"  # 10 minutes default
BITRATE="${3:-20k}"

TEMP_RAW=$(mktemp).wav
TEMP_PROCESSED=$(mktemp).wav
OUTPUT_MP3="$OUTPUT_DIR/brown_noise.mp3"

echo "Generating ${DURATION}s of brown noise..."

# Generate raw brown noise (stereo, 44.1kHz)
sox -n -r 44100 -c 2 "$TEMP_RAW" synth "$DURATION" brownnoise

# Apply audio processing:
#   - highpass 40: cut frequencies below 40Hz to reduce throbbing
#   - lowpass 250: cut frequencies above 250Hz for deep rumble
sox "$TEMP_RAW" "$TEMP_PROCESSED" highpass 40 lowpass 250

# Convert to MP3
ffmpeg -y -i "$TEMP_PROCESSED" -b:a "$BITRATE" "$OUTPUT_MP3"

# Cleanup intermediary files
rm -f "$TEMP_RAW" "$TEMP_PROCESSED"

echo "Generated: $OUTPUT_MP3"
echo "  Duration: ${DURATION}s"
echo "  Bitrate: $BITRATE"
