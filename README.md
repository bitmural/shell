# Bitmural's Quickshell shell

Runs on NixOS unstable using uwsm based Hyprland. The main reason I created this shell was to be able to turn my computer off and connect my bluetooth headphones without the cli. I also don't really like bars. 


https://github.com/user-attachments/assets/c870749c-206b-467f-889f-8ef67872ac79


## Dependencies
- Hyprland
- Quickshell v0.2.0

## Install & Run
After installing the dependencies, copy the repo content into `~/.config/quickshell`, add a `quickshell:desktop` bind in `~/.config/hypr/hyprland.conf` and run `quickshell` from a cli. For running on startup, a simple `exec-onces = uwsm app -- quickshell` in `~/.config/hypr/hyprland.conf` should suffice.

## Use
This is a fullscreen popup style shell, not a bar. Make sure there is an appropriate global bind in `hyprland.conf` such as, `bind = CTRL, SUPER_L, global, quickshell:desktop`.

## Configure
Configuration options are in `~/.config/quickshell/config.json`, including the background image location.

## Future Plans
A couple things were a bit awkward in the user interface and my QML logic. I plan to revisit them to make them work and feel better.
- Bluetooth pairing
- Audio Sources (Input)
- Desktop Tray - doesn't really work at all unfortunately
- Networking - not implemented at all. I'll do that when I need it I guess.

There are also some extra widgets and features that could be fun to figure out or steal from another quickshill. (Probably end_4 or soromane...)
 - CPU & RAM widget
 - Disk space widget
 - Removable disk indicators using udiskie
 - App quick launch buttons
 - Screen dimming and powersave settings
 - Media controls using MPRIS
 - Media visualizer using cava
 - A few more shader effects :)

Some stuff I won't add.
 - App launcher, I use fuzzel
 - Wallpaper, I use hyprpaper
 - Notifications, I use dunst

## Acknowledgements
Doubtful I could have figured out Qt/QML/Quickshell without the examples from [@soromane](https://github.com/soramanew), [@end_4](https://github.com/end-4), and the ongoing discussions of others from the [discord](https://discord.gg/UtZeT3xNyT). Thank you! I also didn't write the included shader. It's a modified shader from [Shadertoy](https://www.shadertoy.com/). I've included a url to the source in every appropriate shader file.
