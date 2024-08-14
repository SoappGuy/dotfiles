import subprocess
import sys

with open("/home/dumbnerd/.scripts/temp/mouse_scale_factor", "r") as file:
    state = float(file.read().strip())

    args = sys.argv[1:]
    if len(args) > 0:
        if args[0] == "inc":
            state += 0.1
        elif args[0] == "dec" and state > 1:
            state -= 0.1
        elif args[0] == "reset":
            state = 1.0

with open("/home/dumbnerd/.scripts/temp/mouse_scale_factor", "w") as file:
    file.write(str(state))

result = subprocess.run(["hyprctl", "keyword", "misc:cursor_zoom_factor", str(state)],
                        check=True, text=True, capture_output=True)

if result.stdout != "ok":
    subprocess.run(["hyprctl",  "notify",  "-1",  "1000", "rgb(0ff00)",
                    result.stdout], check=True, text=True, capture_output=True)
