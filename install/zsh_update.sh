#!/bin/bash

source $DOTFILES/install/utils.sh

# Set zsh plugin directory
ZSH_PLUGINS=$DOTFILES/.local/zsh_plugins

for dir in $ZSH_PLUGINS/*; do
  update_plugin "$(basename "$dir")"
done
