#!/bin/bash

source ~/.scripts/dmenu.sh

mainMenu="Shutdown
Reboot
Sleep
Lock
Logout
Cancel"

pauseMenu="now
+60
+45
+30
+15
+10
+5"

action=$(menu "Option: " "$mainMenu")
[ -z "$action" ] && exit

case "$action" in
    'Shutdown')
        pauseTime=$(menu "Pause: " "$pauseMenu")
        [ -z "$pauseTime" ] && exit

        notify-send "System:" "Shutdown scheduled - $pauseTime"
        sudo shutdown -P "$pauseTime"
    ;;
    'Reboot')
        pauseTime=$(menu "Pause: " "$pauseMenu")
        [ -z "$pauseTime" ] && exit

        notify-send "System:" "Reboot scheduled - $pauseTime"
        sudo shutdown -r "$pauseTime"
    ;;
    'Sleep')
        notify-send "System:" "Suspending now"
        sudo systemctl suspend
    ;;
    'Lock')
	loginctl lock-session
    ;;
    'Logout')
	hyprctl dispatch exit 0
    ;;
    'Cancel')
        notify-send "System:" "Shutdown command cancelled"
        sudo shutdown -c
    ;;
esac
