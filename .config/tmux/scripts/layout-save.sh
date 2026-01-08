#!/usr/bin/env bash
# Save current window layout

LAYOUT_DIR="$HOME/.config/tmux/layouts"
mkdir -p "$LAYOUT_DIR"

LAYOUT_NAME="$1"
if [ -z "$LAYOUT_NAME" ]; then
    echo "Usage: $0 <layout-name>"
    exit 1
fi

CURRENT_LAYOUT=$(tmux display-message -p "#{window_layout}")
echo "$CURRENT_LAYOUT" > "$LAYOUT_DIR/$LAYOUT_NAME.layout"
echo "Layout saved: $LAYOUT_NAME"
