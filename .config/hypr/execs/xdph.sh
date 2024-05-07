#!/usr/bin/bash

sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
hyprctl notify -1 2000 "rgb(00ffff)" "XDPH"
sleep 2
/usr/lib/xdg-desktop-portal &
hyprctl notify -1 1000 "rgb(00ffff)" "XDP"

