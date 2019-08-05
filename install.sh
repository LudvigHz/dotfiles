#!/bin/bash
# Script for installing LudvigHz dotfiles: http://github.com/LudvigHz/dotfiles


# Set dotfiles directory
DOTFILES="$( pwd )"


# Create a directory for local files
if [[ ! -d $DOTFILES/.local ]]; then
  mkdir $DOTFILES/.local
fi

# Create a seperate file for global constants to not reset any local file used by
# another installation.
echo "export DOTFILES=$DOTFILES" > $DOTFILES/.local/constants



# Declare a table of install scripts
declare -A install_scripts=(

  ["zsh"]="$DOTFILES/install/zsh.sh"
  ["vim"]="$DOTFILES/install/vim.sh"

)


if [[ -z "$1" ]]; then
  echo "Usage: $0 [program] [program] ...
  where [program] is one of the following:"
  for i in "${!install_scripts[@]}"; do
    printf "\t%s\n" "$i"
  done
fi


# Run all provided install scripts
for install in "$@"
do
  if [[ ! -z "$install_scripts["$install"]" ]]; then
    echo -e "\e[1mStarting install of $install\e[0m\n"
    bash "${install_scripts[$install]}"
  fi
done
