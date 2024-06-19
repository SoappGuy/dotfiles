#!/bin/sh

report() {
    local dirty="$(grep -w Dirty: /proc/meminfo | cut -d ':' -f 2 | tr -d ' ')"
    echo -n -e "\e[2K\rSyncing ${dirty}... "
}

report
sync &
SYNC_PID=$!
sleep 0.125
while ps -p $SYNC_PID > /dev/null 2>&1; do
    report
    sleep 1
done

echo "Done!"
