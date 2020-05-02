#!/bin/bash

# shellcheck source=utils.sh
source "$DOTFILES/install/utils.sh"
# shellcheck source=../zshrc
source "$DOTFILES/zshrc"

check_install zsh -e

# Set zsh plugin directory
ZSH_PLUGINS=$DOTFILES/.local/zsh_plugins

backup_file "${ZDOTDIR:-$HOME}/.zshrc"
backup_file "${ZDOTDIR:-$HOME}/.zshenv"

#Source zshrc from home folder
echo "source $DOTFILES/.local/zsh" >"${ZDOTDIR:-$HOME}/.zshrc"

echo "source $DOTFILES/.local/constants" >"$DOTFILES/.local/zsh"
echo "export ZSH_PLUGINS=$ZSH_PLUGINS" >>"$DOTFILES/.local/zsh"
echo "source $DOTFILES/zshrc" >>"$DOTFILES/.local/zsh"

# Source zshenv config from home folder
echo "source $DOTFILES/zshenv" >"${ZDOTDIR:-$HOME}/.zshenv"

echo "Cloning and setting up dependencies"

# Load (install) plugins
for plugin in $plugins; do
  load_plugin "$plugin"
done

# Load (install) oh-my-zsh plugins
for plugin in $oh_my_zsh_plugins; do
  load_oh-my-zsh_plugin "$plugin"
done

echo -e "\nInstalling zsh - DONE\n"
