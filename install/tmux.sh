#!/bin/bash

# shellcheck source=utils.sh
source "$DOTFILES/install/utils.sh"

# check if tmux is intalled
check_install tmux -e

backup_file "$HOME/.tmux.conf"

echo "source $DOTFILES/tmux.conf" >"$HOME/.tmux.conf"

echo -e "\nInstalling tmux - DONE\n"
