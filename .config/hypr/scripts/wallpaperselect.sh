#!/usr/bin/env bash

# set variables
RofiConf="$HOME/.config/rofi/wallpaper/wallpaperselect.rasi"
wallPath="$HOME/wallpapers/"


# launch rofi menu
RofiSel=$( find -L "${wallPath}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | sort | while read rfile
    do
        echo -en "$rfile\x00icon\x1f${wallPath}/${rfile}\n"
done | rofi -show -dmenu -theme  "${RofiConf}" -select "${currentWall}")

# apply wallpaper
if [ ! -z "${RofiSel}" ] ; then
    selected="${wallPath}/${RofiSel}"

    swww img $selected \
        --transition-type "wipe" \
        --transition-duration 1

    notify-send "Wallpaper ${RofiSel}" -a "Wallpaper" -i "${wallPath}/${RofiSel}" -t 2200
    ln -sf "$selected" "$HOME/.config/swww/.current_wallpaper"

    # wal -i "${selected}"
    matugen image "${selected}"
    . ~/.config/hypr/scripts/matugen-apply.sh
fi

