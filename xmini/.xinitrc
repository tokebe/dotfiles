#!/usr/bin/env bash

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#. /etc/X11/Xsession &
#xrdb ~/.Xresources &
#xrdb -merge ~/.Xresources &
#xterm -geometry 60x19+12+4 -fs 14 -fa "Tokebe Nerd Font"
xscreensaver -no-splash &
xterm
