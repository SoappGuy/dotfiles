#!/bin/sh
# This wrapper script is invoked by xdg-desktop-portal-termfilechooser.
#
# Inputs:
# 1. "1" if multiple files can be chosen, "0" otherwise.
# 2. "1" if a directory should be chosen, "0" otherwise.
# 3. "0" if opening files was requested, "1" if writing to a file was
#    requested. For example, when uploading files in Firefox, this will be "0".
#    When saving a web page in Firefox, this will be "1".
# 4. If writing to a file, this is recommended path provided by the caller. For
#    example, when saving a web page in Firefox, this will be the recommended
#    path Firefox provided, such as "~/Downloads/webpage_title.html".
#    Note that if the path already exists, we keep appending "_" to it until we
#    get a path that does not exist.
# 5. The output path, to which results should be written.
#
# Output:
# The script should print the selected paths to the output path (argument #5),
# one path per line.
# If nothing is printed, then the operation is assumed to have been canceled.

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

cmd="/usr/bin/yazi"
termcmd="${TERMCMD:-/usr/bin/alacritty}"

if [ "$save" = "1" ]; then
    set -- --chooser-file="$out" "$path"
    printf '%s' 'select file to save' > "$path"
elif [ "$directory" = "1" ]; then
    set -- --cwd-file="$out" "$path"
elif [ "$multiple" = "1" ]; then
    set -- --chooser-file="$out" "$path"
else
    set -- --chooser-file="$out"
fi

"$termcmd" -- $cmd "$@"
if [ "$save" = "1" ] && [ ! -s "$out" ]; then
    rm "$path"
fi
