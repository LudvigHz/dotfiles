#!/bin/bash

source "$DOTFILES/install/utils.sh"

backup_file $HOME/.tmux.conf

echo "source $DOTFILES/tmux.conf" > $HOME/.tmux.conf

echo -e "\nInstalling tmux - DONE\n"
