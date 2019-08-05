#!/bin/bash

# load plugins from github
# syntax: load_plugin "zsh-users/syntax-highlighting"
load_plugin() {

  local plugin_name="$(echo $1 | awk '{split($0,a,"/"); print a[2]}')"
  if [[ ! -d "$ZSH_PLUGINS/$plugin_name" ]]; then
    echo -e "\e[1mInstalling $1...              \c"
    git clone "https://github.com/$1.git" $ZSH_PLUGINS/$plugin_name
  else
    echo -e "\e[1m$1\e[0m is already installed."
  fi

}


# Load plugins from oh-my-zsh
# Syntax: load_oh-my-zsh_plugin "sudo"
# **Requires svn to be installed**
load_oh-my-zsh_plugin() {

  if [[ ! -d "$ZSH_PLUGINS/$1" ]]; then
    echo -e "\e[1mInstalling $1...              \c"
    svn export --quiet "https://github.com/robbyrussell/oh-my-zsh/trunk/plugins/$1" $ZSH_PLUGINS/$1
    echo -e "\e[1;94mDONE"
  else
    echo -e "\e[1m$1\e[0m is already installed."
  fi

}


# Create a backup of a file in the "$DOTFILES/.local/backup" directory
# Syntax: backup_file "path-to-file"
backup_file() {

  if [[ -a $1 ]]; then

    if [[ -d $DOTFILES/backup ]]; then
      mkdir $DOTFILES/.local/backup
    fi

    local filename=$(basename $1)

    cp $1 $DOTFILES/.local/backup/$filename

    echo "Created a backup of '$1' in: $DOTFILES/.local/backup/$filename"

  fi
}
