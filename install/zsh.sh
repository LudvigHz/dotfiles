#!/bin/bash

source $DOTFILES/install/utils.sh

# Set zsh plugin directory
ZSH_PLUGINS=$DOTFILES/.local/zsh_plugins

backup_file $HOME/.zshrc

#Source zshrc from home folder
echo "source $DOTFILES/.local/zsh" > ${ZDOTDIR:-$HOME}/.zshrc

echo "export ZSH_PLUGINS=$ZSH_PLUGINS" > $DOTFILES/.local/zsh
echo "source $DOTFILES/zshrc" >> $DOTFILES/.local/zsh

# Source zshenv config from home folder
echo "source $DOTFILES/.local/zshenv" > ${ZDOTDIR:-$HOME}/.zshenv
echo "source $DOTFILES/zshenv" > $DOTFILES/.local/zshenv

echo "Cloning and setting up dependencies"

load_plugin "zsh-users/zsh-autosuggestions"
load_plugin "zsh-users/zsh-syntax-highlighting"
load_plugin "zsh-users/zsh-completions"
load_plugin "zsh-users/zsh-history-substring-search"
load_plugin "b4b4r07/enhancd"
load_plugin "LudvigHz/k"

load_oh-my-zsh_plugin "sudo"

echo -e "\nInstalling zsh - DONE\n"
