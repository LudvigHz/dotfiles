#!/bin/bash

# Set dotfiles directory
DOTFILES="$( pwd )"


if [[ ! -d $DOTFILES/.local ]]; then
  mkdir $DOTFILES/.local
fi

echo "export DOTFILES=$DOTFILES" > $DOTFILES/.local/zsh



# Declare a table of install scripts
declare -A install_scripts=(

  ["zsh"]="$DOTFILES/install/zsh.sh"

)


# Run all provided install scripts
for install in "$@"
do
  if [[ ! -z "$install_scripts["$install"]" ]]; then
    echo -e "\e[1mStarting install of $install\e[0m\n"
    bash "${install_scripts[$install]}"
  fi
done
