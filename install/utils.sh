#!/bin/bash

# load plugins from github
# TODO allow loading from oh-my-zsh
# syntax: load_plugin "zsh-users/syntax-highlighting"
load_plugin() {

  local plugin_name="$(echo $1 | awk '{split($0,a,"/"); print a[2]}')"
  if [[ ! -d "$ZSH_PLUGINS/$plugin_name" ]]; then
    git clone "https://github.com/$1.git" $ZSH_PLUGINS/$plugin_name
  else
    echo -e "\e[1m$1\e[0m is already installed."
  fi

}
