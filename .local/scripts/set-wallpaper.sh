#!/bin/bash
# Usage: set-wallpaper.sh /path/to/image.jpg
IMAGE="$(realpath "$1")"
CONFIG="$HOME/.config/cosmic/com.system76.CosmicBackground/v1/all"

cat > "$CONFIG" << EOF
(
    output: "all",
    source: Path("$IMAGE"),
    filter_by_theme: true,
    rotation_frequency: 300,
    filter_method: Lanczos,
    scaling_mode: Zoom,
    sampling_method: Alphanumeric,
)
EOF

notify-send "Wallpaper changed" "$(basename "$IMAGE")"
