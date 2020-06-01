#!/bin/bash

if [[ $(id -u) -eq 0 ]]; then
	echo error: you cannot run this script as root
	exit
fi

packages=(
	base-devel
	xorg-server
	xorg-xinit
	xorg-xrdb
	numlockx
	mesa
	sudo
	rxvt-unicode
	zsh
	zsh-completions
	man
	feh
	i3-wm
	i3status
	dmenu
	vim
	git
	ranger
	screenfetch
	mpv
	mpd
	alsa-utils
	chromium
	pulsemixer
	playerctl
)

aur_packages=(
	ttf-envy-code-r
	spotify
)

sudo pacman -Syu --noconfirm

sudo pacman -Sq --needed --noconfirm ${packages[@]}

for pkg in ${aur_packages[@]}; do
	cd /tmp
	git clone https://aur.archlinux.org/$pkg.git
	cd $pkg
	makepkg -si --needed --noconfirm
	cd ..
	rm -rf ./$pkg
done

cd /tmp
git clone https://github.com/jmckiern/dotfiles.git
./dotfiles/linux/install-config-files.sh
rm -rf dotfiles

echo Downloading vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

git config --global user.email "jmckiern@tcd.ie"
git config --global user.name "jmckiern"
git config --global core.editor vim
