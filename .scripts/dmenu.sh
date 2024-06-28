
function menu
{
    # Grab the prompt message.
    local prompt="$1"
    shift

    echo "$@" | dmenu -fn 'JetBrainsMonoNL NF Regular' -sf \#EEEEEC -sb \#962AC3 -h 38 -p "$prompt" -i
}


