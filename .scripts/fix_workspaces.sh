#/bin/bash

hyprctl dispatch moveworkspacetomonitor 1 HDMI-A-2
hyprctl dispatch moveworkspacetomonitor 2 HDMI-A-2
hyprctl dispatch moveworkspacetomonitor 3 HDMI-A-2

hyprctl dispatch moveworkspacetomonitor 4 eDP-1
hyprctl dispatch moveworkspacetomonitor 5 eDP-1
hyprctl dispatch moveworkspacetomonitor 6 eDP-1

hyprctl notify 1 1000 0 done 
