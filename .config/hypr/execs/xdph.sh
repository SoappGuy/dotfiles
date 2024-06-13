#!/usr/bin/bash

sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
hyprctl notify -1 2000 "rgb(00ffff)" "XDP-H"
sleep 0.2
/usr/lib/xdg-desktop-portal-gtk &
hyprctl notify -1 2000 "rgb(00ffff)" "XDP-GTK"
sleep 0.2
/usr/lib/xdg-desktop-portal-gnome &
hyprctl notify -1 2000 "rgb(00ffff)" "XDP-GNOME"
sleep 0.2
/usr/lib/xdg-desktop-portal &
hyprctl notify -1 1000 "rgb(00ffff)" "XDP"

