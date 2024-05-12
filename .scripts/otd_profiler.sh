#!/bin/bash

SELECTED_FILE=$(ls "$HOME/.config/OpenTabletDriver/Presets/" | rofi -dmenu -p "Select a file:" -theme /home/dumbnerd/.config/rofi/launchers/type-1/style-5.rasi)

# Check if a file was selected
if [ -z "$SELECTED_FILE" ]; then
    hyprctl notify -1 3000 "rgb(ff0000)" "Aborting"
    exit 1
fi


otd applypreset ${SELECTED_FILE%.*}
hyprctl notify -1 3000 "rgb(00ff00)" "Profile \"${SELECTED_FILE%.*}\" applied"
