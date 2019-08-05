#!/bin/bash

print_help() {

  printf "Usage: install.sh cli-tools [options]\n"
  printf "\tOptions:\n"
  printf "\t%s\t%s\n" \
    "-a|--all" "Install all tools" \
    "-n|--name [n]" "Install a single tool. Run with -l to see list of tools" \
    "-f|--force" "Force intstall even though the command exists" \
    "-u|--use [m]" "Specify your package manager (default: apt)" \
    "-h|--help" "Print this help message" \
    "-l|--list" "List all cli tools that will be installed" \
    "--list-managers" "List all supported package managers for use for -u"

}

# Table of package managers and their install commands
declare -A installers=(

  ["apt"]="sudo apt-get install -y "
  ["pacman"]="sudo pacman -S "
  ["dnf"]="sudo dnf install "
  ["pkg"]="pkg install "
  ["zypper"]="sudo zypper install "
  ["brew"]="brew install "
  ["snap"]="snap install "

)

# Declare a table of tools that should be installed
declare -A cli_tools=(

  #["program"]="command"

  ["zsh"]="zsh"
  ["vim"]="vim"
  ["neovim"]="nvim"
  ["fzf"]="fzf"
  ["subversion"]="svn"
  ["git"]="git"
  ["ripgrep"]="rg"
  ["tmux"]="tmux"
  ["gawk"]="awk"
  ["rxvt-unicode"]="urxvt"
  ["zathura"]="zathura"
  ["tweak-tools"]="gnome-tweak-tools"

)


# Function to print keys from an associative array
print_all() {

  printf "Cli-tools to be installed:\n"
  for i in "${!cli_tools[@]}"; do
    printf "\t%s\n" "$i"
  done

}

# Function for installing a given utility
install_program() {
  echo $2

  if [[ ! $force ]]; then
    if [[ $(command -v "${cli_tools["$1"]}") ]]; then
      printf "%s is already installed, use -f option to force install.\n" "$1"
    else
      printf "Installing %s using %s\n\n" "$1" "$manager"
      eval "${installers["$manager"]} "${cli_tools["$1"]}" "
    fi
  else
    printf "Installing %s using %s\n\n" "$1" "$manager"
    eval "${installers["$manager"]} "
  fi

}


manager="apt"

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -a|--all)
      install_all=true
      shift
      ;;
    -f|--force)
      force=true
      shift
      ;;
    -n|--name)
      cli_tool="$2"
      shift
      shift
      ;;
    -u|--use)
      manager="$2"
      shift
      shift
      ;;
    -h|--help)
      print_help
      exit 1
      ;;
    -l|--list)
      print_all
      exit 1
      ;;
    --list-managers)
      printf "Supported package managers:\n"
      for i in "${!installers[@]}"; do
        printf "\t%s\n" "$i"
      done
      exit 1
      ;;
    *)
      shift
      ;;
  esac
done


if [[ ! -z $cli_tool ]]; then
  install_program "$cli_tool"
elif [[ $install_all ]]; then
  for prog in "${!cli_tools[@]}"; do
    install_program "$prog"
  done
else
  print_help
fi