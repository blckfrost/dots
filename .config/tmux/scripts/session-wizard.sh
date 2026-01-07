#!/usr/bin/env bash
# Quick session creator from common project directories

DIRS=(
    "$HOME/dev/AHH"
    "$HOME/dev/private/CERV/"
    "$HOME/dev/private/"
    "$HOME/dev/public"
    "$HOME/dev/cloned"
    "$HOME/dev/golang/"
    "$HOME/dev"
    "$HOME/dev"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path --base-directory $HOME |
        sed "s|^$HOME/||" |
        fzf --prompt="Select project: " --height 40% --reverse)

    [[ $selected ]] && selected="$HOME/$selected"
fi

if [ -z "$selected" ]; then
    exit 0
fi

PROJECT_PATH="$selected"
SESSION_NAME=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux new-session -ds "$SESSION_NAME" -c "$PROJECT_PATH"
    tmux select-window -t "$SESSION_NAME:1"
fi

if [ -z "$TMUX" ]; then
    tmux attach-session -t "$SESSION_NAME"
else
    tmux switch-client -t "$SESSION_NAME"
fi
