#!/bin/bash

source "$DOTFILES/install/utils.sh"

backup_file $HOME/.Xresources

echo '#include "./dotfiles/Xresources"' > $HOME/.Xresources

echo -e "\nInstalling Xresources - DONE\n"
