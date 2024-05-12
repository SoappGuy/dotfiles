state=$(makoctl mode) || "default";

if [ "$state" == "" ]; then
    state="default";
fi

if [ "$1" == "switch" ]; then
    if [ "$state" == "dnd" ]; then
        makoctl mode -r dnd;
        makoctl mode -a default;
        state="default";
    else
        makoctl mode -a dnd;
        makoctl mode -r default;
        state="dnd";
    fi
elif [ "$1" == "restore" ]; then
    makoctl restore;
fi

echo "{\"text\": \"\", \"class\": \"mako\", \"alt\": \"$state\"}";
