#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# CONFIG
# -----------------------------------------------------------------------------
WORK_SESH=1500
SHORT_BREAK=300
LONG_BREAK=900
CYCLE_COUNT=4

ICON_WORK="󱫡"
ICON_BREAK="󱫟"
ICON_PAUSED="󱫍"
ICON_DONE="󱫑"

STATE_FILE="/tmp/waybar_pomodoro.state"
PID_FILE="/tmp/waybar_pomodoro.pid"

# -----------------------------------------------------------------------------
# STATE FORMAT
# STATE|DURATION|START|PAUSE_REM|MODE|COUNT
# -----------------------------------------------------------------------------

init_state() {
    echo "IDLE|0|0|0|WORK|0" >"$STATE_FILE"
}

read_state() {
    IFS='|' read -r STATE DURATION START PAUSE_REM MODE COUNT <"$STATE_FILE"
}

write_state() {
    echo "$1|$2|$3|$4|$5|$6" >"$STATE_FILE"
}

format_time() {
    printf "%02d:%02d" $(($1 / 60)) $(($1 % 60))
}

notify() {
    notify-send "Pomodoro" "$1"
}

signal_update() {
    [ -f "$PID_FILE" ] && kill -SIGUSR1 "$(cat "$PID_FILE")" 2>/dev/null
}

# -----------------------------------------------------------------------------
# INPUT HANDLER (Waybar clicks)
# -----------------------------------------------------------------------------
if [ -n "$1" ]; then
    [ ! -f "$STATE_FILE" ] && init_state
    read_state
    NOW=$(date +%s)

    case "$1" in
    click)
        case "$STATE" in
        IDLE)
            write_state "RUNNING" "$WORK_SESH" "$NOW" 0 "WORK" "$COUNT"
            ;;
        RUNNING)
            REM=$((DURATION - (NOW - START)))
            write_state "PAUSED" "$DURATION" 0 "$REM" "$MODE" "$COUNT"
            ;;
        PAUSED)
            NEW_START=$((NOW - DURATION + PAUSE_REM))
            write_state "RUNNING" "$DURATION" "$NEW_START" 0 "$MODE" "$COUNT"
            ;;
        esac
        ;;
    right)
        write_state "IDLE" 0 0 0 "WORK" 0
        ;;
    esac

    signal_update
    exit 0
fi

# -----------------------------------------------------------------------------
# MAIN LOOP (Waybar output)
# -----------------------------------------------------------------------------
[ ! -f "$STATE_FILE" ] && init_state
echo $$ >"$PID_FILE"
trap : SIGUSR1

while true; do
    read_state
    NOW=$(date +%s)

    case "$STATE" in
    IDLE)
        echo "{\"text\":\"🍅 00:00\",\"class\":\"idle\",\"tooltip\":\"Pomodoro\\nClick to start\"}"
        sleep infinity &
        wait $!
        ;;
    PAUSED)
        ICON="$ICON_PAUSED"
        echo "{\"text\":\"$ICON $(format_time $PAUSE_REM)\",\"class\":\"paused\",\"tooltip\":\"Paused\\nClick to resume\"}"
        ;;
    RUNNING)
        REM=$((DURATION - (NOW - START)))

        if [ "$REM" -le 0 ]; then
            if [ "$MODE" = "WORK" ]; then
                COUNT=$((COUNT + 1))
                if [ "$COUNT" -ge "$CYCLE_COUNT" ]; then
                    notify "Long break 🛌"
                    write_state "RUNNING" "$LONG_BREAK" "$NOW" 0 "BREAK" 0
                else
                    notify "Short break ☕"
                    write_state "RUNNING" "$SHORT_BREAK" "$NOW" 0 "BREAK" "$COUNT"
                fi
            else
                notify "Focus time 🍅"
                write_state "RUNNING" "$WORK_SESH" "$NOW" 0 "WORK" "$COUNT"
            fi
            signal_update
            continue
        fi

        if [ "$MODE" = "WORK" ]; then
            ICON="$ICON_WORK"
            CLASS="work"
            TIP="Working 🍅"
        else
            ICON="$ICON_BREAK"
            CLASS="break"
            TIP="Break ☕"
        fi

        echo "{\"text\":\"$ICON $(format_time $REM)\",\"class\":\"$CLASS\",\"tooltip\":\"$TIP\"}"
        ;;
    esac

    sleep 1 &
    wait $!
done
