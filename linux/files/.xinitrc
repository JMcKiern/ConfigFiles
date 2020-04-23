[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
sh ~/.fehbg &
exec i3
