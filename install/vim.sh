#!/bin/bash

source $DOTFILES/install/utils.sh

backup_file $HOME/.vimrc

echo "source $DOTFILES/vimrc" > $HOME/.vimrc
