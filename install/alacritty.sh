#!/bin/bash

# shellcheck source=utils.sh
source "$DOTFILES/install/utils.sh"

# check if alacritty is intalled
check_install alacritty -e

backup_file "$HOME/.config/alacritty/alacritty.yml"

rm -f "$HOME/.config/alacritty/alacritty.yml"
mkdir -p "$HOME/.config/alacritty"

ln -s "$DOTFILES/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"

echo -e "\nInstalling alacritty - DONE\n"
