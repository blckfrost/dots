#!/usr/bin/env bash
# Kill multiple tmux sessions interactively

SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

if [ -z "$SESSIONS" ]; then
    echo "No sessions found"
    exit 0
fi

SELECTED=$(echo "$SESSIONS" | fzf --multi --prompt="Select sessions to kill: " \
    --height 40% --reverse --preview "tmux list-windows -t {}")

if [ -n "$SELECTED" ]; then
    echo "$SELECTED" | xargs -I {} tmux kill-session -t {}
    echo "Sessions killed"
fi
