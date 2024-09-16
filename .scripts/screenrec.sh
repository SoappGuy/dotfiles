#!/usr/bin/env bash

VIDEOS_DIR="$HOME/Videos"
FILENAME="$(date +'%B %d | %H:%M:%S | output.mp4')"
START_TIME=0

start_recording() {
    echo "$(date +%s)" > "/tmp/screenrec_start_time"
    wf-recorder -g "$(slurp)" -f "$VIDEOS_DIR/$FILENAME" -y &
}

show_status() {
    if pgrep -x "wf-recorder" > /dev/null; then
        START_TIME=$(cat "/tmp/screenrec_start_time")
        CURRENT_TIME=$(date +%s)

        ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
        MINUTES=$((ELAPSED_TIME / 60))
        SECONDS=$((ELAPSED_TIME % 60))

        printf '{"text": "%02d:%02d", "class": "in_progres", "alt": "in_progres"}\n' "$MINUTES" "$SECONDS"
    else
        printf '{"text": "", "class": "none", "alt": "none"}\n'
    fi
}

stop_recordings() {
    if pkill -x "wf-recorder"; then
        last_recording=$(ls -t "$VIDEOS_DIR"/*.mp4 | head -n1)

        if [ -n "$last_recording" ]; then
            echo "file://$last_recording" | wl-copy -t 'text/uri-list'
        fi
    fi
}

case "$1" in
    start)
        start_recording
        ;;
    status)
        show_status
        ;;
    stop)
        stop_recordings
        ;;
    *)
        echo "Usage: $0 {start|status|stop}"
        ;;
esac
