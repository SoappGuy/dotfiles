#!/usr/bin/env bash

VIDEOS_DIR="$HOME/Videos/Screenrecs"
FILENAME="$(date +'%B %d | %H:%M:%S.mp4')"
START_TIME=0

start_recording() {
    GEOMETRY="$(slurp -o)"
    wf-recorder -g "$GEOMETRY" -f "$VIDEOS_DIR/$FILENAME" -y --audio="$*" &
    date +%s > "/tmp/screenrec_start_time"
}

show_status() {
    if pgrep -x "wf-recorder" > /dev/null; then
        START_TIME=$(cat "/tmp/screenrec_start_time")
        CURRENT_TIME=$(date +%s)

        ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
        MINUTES=$((ELAPSED_TIME / 60))
        SECONDS=$((ELAPSED_TIME % 60))

        printf '{"text": "%02d:%02d ", "class": "in_progres", "alt": "in_progres"}\n' "$MINUTES" "$SECONDS"
    else
        printf '{"text": "", "class": "none", "alt": "none"}\n'
    fi
}

stop_recording() {
    if pkill -x "wf-recorder"; then
        last_recording=$(ls -t "$VIDEOS_DIR"/*.mp4 | head -n1)
        rm /tmp/screenrec_start_time

        if [ -n "$last_recording" ]; then
            echo "file://$last_recording" | wl-copy -t 'text/uri-list'
        fi
    fi
}

toggle_recording() {
    if pgrep "wf-recorder" > /dev/null; then
        stop_recording
    else 
        start_recording "$@"
    fi
}

case "$1" in
    start)
        start_recording "$@"
        ;;
    status)
        show_status
        ;;
    stop)
        stop_recording
        ;;
    toggle)
        toggle_recording "$@"
        ;;
    togglea)
        toggle_recording "-a=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep 'node.name' | sed -n 's/.*node.name = "\(.*\)"/\1/p' | sed 's/alsa_output/alsa_input/; s/$/.monitor/')"
        ;;
    *)
        echo "Usage: $0 {start|status|stop|toggle}"
        ;;
esac
