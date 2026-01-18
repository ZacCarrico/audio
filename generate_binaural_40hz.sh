#!/bin/bash
# Generate 40Hz binaural beat for focus (requires headphones)
# Left ear: 200Hz, Right ear: 240Hz -> Brain perceives 40Hz gamma
# Requirements: sox, ffmpeg
#   brew install sox ffmpeg

set -e

OUTPUT_DIR="${1:-.}"
DURATION="${2:-60}"  # 1 minute default
BITRATE="${3:-64k}"   # Higher bitrate for tonal accuracy

TEMP_LEFT=$(mktemp).wav
TEMP_RIGHT=$(mktemp).wav
TEMP_STEREO=$(mktemp).wav
OUTPUT_MP3="$OUTPUT_DIR/binaural_40hz.mp3"

echo "Generating ${DURATION}s of 40Hz binaural beat..."

# Generate left channel (200Hz) and right channel (240Hz)
sox -n -r 44100 -c 1 "$TEMP_LEFT" synth "$DURATION" sine 200
sox -n -r 44100 -c 1 "$TEMP_RIGHT" synth "$DURATION" sine 240

# Merge into stereo file
sox -M "$TEMP_LEFT" "$TEMP_RIGHT" "$TEMP_STEREO"

# Convert to MP3
ffmpeg -y -i "$TEMP_STEREO" -b:a "$BITRATE" "$OUTPUT_MP3"

# Cleanup intermediary files
rm -f "$TEMP_LEFT" "$TEMP_RIGHT" "$TEMP_STEREO"

echo "Generated: $OUTPUT_MP3"
echo "  Duration: ${DURATION}s"
echo "  Bitrate: $BITRATE"
echo "  Note: Use headphones for binaural effect"
