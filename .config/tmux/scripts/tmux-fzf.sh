#!/usr/bin/env bash
# Universal tmux fuzzy finder - windows, panes, sessions

ACTION="${1:-switch}"

case "$ACTION" in
    switch)
        # Switch to window/session
        ITEM=$(tmux list-windows -a -F "#{session_name}:#{window_index} - #{window_name}" | \
            fzf --prompt="Switch to: " --height 40% --reverse)
        if [ -n "$ITEM" ]; then
            TARGET=$(echo "$ITEM" | awk '{print $1}')
            tmux switch-client -t "$TARGET"
        fi
        ;;
    kill-pane)
        # Kill pane
        PANE=$(tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} - #{pane_current_command}" | \
            fzf --prompt="Kill pane: " --height 40% --reverse)
        if [ -n "$PANE" ]; then
            TARGET=$(echo "$PANE" | awk '{print $1}')
            tmux kill-pane -t "$TARGET"
        fi
        ;;
    *)
        echo "Usage: $0 {switch|kill-pane}"
        exit 1
        ;;
esac
