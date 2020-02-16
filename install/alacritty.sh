#!/bin/bash

source "$DOTFILES/install/utils.sh"

# check if alacritty is intalled
check_install alacritty -e

backup_file $HOME/.config/alacritty/alacritty.yml

rm $HOME/.config/alacritty/alacritty.yml

ln -s $DOTFILES/alacritty.yml $HOME/.config/alacritty/alacritty.yml

echo -e "\nInstalling alacritty - DONE\n"
