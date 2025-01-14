#!/usr/bin/env python

import argparse
import subprocess
import sys
from datetime import datetime

if __name__ == '__main__':
    now = datetime.now()

    parser = argparse.ArgumentParser(description='Process some files.')
    parser.add_argument(
        '-m', '--mode',
        choices=['screen', 'window', 'region', 'next'],
        help='What to save',
        required=True
    )
    parser.add_argument('-i', '--interactive', help='Annotate after', action='store_true')
    parser.add_argument('-a', '--active', help='Save active mode zone', action='store_true')

    args = parser.parse_args()

    tmp_interactive = False
    try:
        with open("/tmp/screnshot_mode", "r+") as file:
            content = file.read().strip()

            if args.mode == 'next':
                if not bool(content):
                    file.write("interactive")
                else:
                    file.seek(0)
                    file.truncate()

                sys.exit()

            file.seek(0)
            file.truncate()

        tmp_interactive = bool(content)
    except FileNotFoundError:
        tmp_interactive = False

    command = ["hyprshot -z"]

    if args.active:
        command.append("-m active")

    match args.mode:
        case "screen":
            command.append(f'-m output -f "{now.strftime("%B %d | %H:%M:%S")} | output.png"')
        case "window":
            command.append(f'-m window -f "{now.strftime("%B %d | %H:%M:%S")} | window.png"')
        case "region":
            if args.active:
                sys.exit("Error: region can't be active")
            command.append(f'-m region -f "{now.strftime("%B %d | %H:%M:%S")} | region.png"')

    command.append(f'-o ~/Pictures/Screenshots')

    if args.interactive or tmp_interactive:
        command.append("--clipboard-only --raw | satty -f -")

    process = subprocess.Popen(" ".join(command),
                               shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    process.wait()
