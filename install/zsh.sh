#!bin/bash

source $DOTFILES/install/utils.sh

# Set zsh plugin directory
ZSH_PLUGINS=$DOTFILES/zsh_plugins


add_if_not_present() {
  grep -Fxq "$1" "$2" || echo "$1" >> "$2"
}


#Source these from home folder
echo "source $DOTFILES/.local/zsh" > ~/.zshrc


echo "export ZSH_PLUGINS=$ZSH_PLUGINS" >> $DOTFILES/.local/zsh
echo "source $DOTFILES/zshrc" >> $DOTFILES/.local/zsh

echo "Cloning and setting up dependencies"

load_plugin "zsh-users/zsh-autosuggestions"
load_plugin "zsh-users/zsh-syntax-highlighting"
load_plugin "zsh-users/zsh-completions"
load_plugin "zsh-users/zsh-history-substring-search"
load_plugin "b4b4r07/enhancd"
load_plugin "LudvigHz/k"

echo -e "\nInstalling zsh - DONE"
