#!/usr/bin/env bash

### CONFIG ###
ROFI_CONF="$HOME/.config/rofi/wallpaper/wallpaperselect.rasi"
WALL_DIR="$HOME/wallpapers"
THUMB_DIR="$HOME/.cache/wall-thumbs"
THUMB_SIZE="400x600"

### INIT ###
mkdir -p "$THUMB_DIR"

### GENERATE THUMBNAILS (only if missing) ###
find -L "$WALL_DIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    -print0 | while IFS= read -r -d '' img; do
    base="$(basename "$img")"
    thumb="$THUMB_DIR/${base}.png"

    if [ ! -f "$thumb" ]; then
        magick "$img" \
            -resize "${THUMB_SIZE}^" \
            -gravity center \
            -extent "$THUMB_SIZE" \
            "$thumb"
    fi
done

### ROFI MENU ###
RofiSel=$(
    find -L "$WALL_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        -exec basename {} \; | sort | while read -r rfile; do
        thumb="$THUMB_DIR/${rfile}.png"
        echo -en "$rfile\x00icon\x1f$thumb\n"
    done | rofi -show -dmenu -theme "$ROFI_CONF"
)

### APPLY WALLPAPER ###
if [ -n "$RofiSel" ]; then
    selected="$WALL_DIR/$RofiSel"

    awww img "$selected" \
        --transition-type wave \
        --transition-duration 4 \
        --transition-angle 20

    notify-send "Wallpaper set" "$RofiSel" \
        -a "Wallpaper" \
        -i "$selected" \
        -t 2200

    ln -sf "$selected" "$HOME/.config/awww/.current_wallpaper"

    # Color scheme
    matugen image "$selected"
    . "$HOME/.config/hypr/scripts/matugen-apply.sh"
fi
