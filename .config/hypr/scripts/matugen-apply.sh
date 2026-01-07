#!/usr/bin/env bash

#pywal-discord
#walogram -s > /dev/null
pywalfox update
spicetify apply -q -n

# set gtk theme
gsettings set org.gnome.desktop.interface gtk-theme ""
gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
