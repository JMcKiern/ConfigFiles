[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
~/.fehbg &
exec i3
