if test -d /proc/sys/net/ipv4/conf/my_laptop; then
    current_state="enabled"
else
    current_state="disabled"
fi


if [ "$1" == "switch" ]; then
    if [ "$current_state" == "enabled" ]; then
        sudo wg-quick down my_laptop
    else
        sudo wg-quick up my_laptop
    fi
fi

echo "{\"text\": \"VPN\", \"class\": \"$current_state\"}"
