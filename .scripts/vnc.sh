#!/usr/bin/env bash

# NETWORK_ADAPTER="wlp4s0"
NETWORK_ADAPTER="wlp61s0"
PORT="5900"

get_local_ip() {
    ip addr show "$NETWORK_ADAPTER" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1
}

kill_wayvnc() {
    if pgrep wayvnc > /dev/null; then
        wayvncctl wayvnc-exit 2> /dev/null
        hyprctl output remove VNC > /dev/null
        notify-send -u low "wayvnc" "VNC server stopped via IPC"
    fi
}

start_wayvnc() {
    local_ip=$(get_local_ip)
    notify-send -u normal "vnc" "Starting VNC server on $local_ip/$PORT"

    hyprctl output create headless VNC > /dev/null

    wayvnc --output VNC 0.0.0.0 $PORT 2> /dev/null & wayvncctl --wait --json event-receive 2> /dev/null | while read -r line; do
        method=$(echo "$line" | jq -r .method)

        if [ "$method" == "client-connected" ]; then
            address=$(echo "$line" | jq -r .params.address)
            notify-send -u critical "vnc" "Client connected: $address"

        elif [ "$method" == "client-disconnected" ]; then
            notify-send -u low "vnc" "Client disconnected"
        fi
    done
}

show_help() {
    echo "Usage: $0 {help|toggle}"
    echo
    echo "Commands:"
    echo "  toggle       Toggle WayVNC server on/off"
    echo "  help         Show this help message"
    echo
    echo "Important:"
    echo "  Figure out best options for you and then change defaults inside the script (PORT and NETWORK_ADAPTER)"
    echo
    echo "  Do not forget about allowing the chosen port connection using your firewall:"
    echo "  sudo ufw allow PORT/tcp"
    echo
    echo "  Specify virtual monitor dimensions in your Hyprland config to be the same as your display:"
    echo "  monitor = VNC, 2400x1080, auto, 1.5"
}

case "$1" in
    toggle)
        if pgrep wayvnc > /dev/null; then
            kill_wayvnc
        else
            start_wayvnc
        fi
        ;;
    help|*)
        show_help
        ;;
esac
