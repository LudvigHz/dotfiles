# dots
# Run the dotfiles script from anywhere
dots() {
  cd "$DOTFILES" && ./install.sh $@
  cd - >>/dev/null
}

# Read MarkDown
rmd() {
  pandoc $1 | lynx -stdin
}


# Search and install from apt with fzf
# Optional argument to shorten search list
asp() {
  local inst=$(apt-cache search "${1:-.}" | eval "fzf -m --header='[apt install]'")
  if [[ $inst ]]; then
    local name=$(echo $inst | head -n1 | awk '{print $1;}')
    if [[ ! -z "$(apt list --installed 2>/dev/null | grep -e "^$name/")" ]]; then
      echo -e "\e[1m$name\e[0m is alredy installed: (u)pdate or (r)emove [ENTER to cancel]: \c"
      read option
      if [[ $option == "u" || $option == "U" ]]; then
        echo -e "\e[1mUpgrading: \e[1;94m$inst\e[0m \n"
        sudo apt install $name
      elif [[ $option == "r" || $option == "R" ]]; then
        echo -e "\e[1mRemoving: \e[1;94m$inst\e[0m \n"
        sudo apt remove $name
      fi
    else
      echo -e "\e[1mInstalling: \e[1;94m$inst\e[0m \n"
      sudo apt install $name
    fi
  fi
}


# rg - less
# pipe rg to less to not spam terminal buffer
rgl() {
  rg $@ -p --line-buffered | less -R
}

# Testing truecolor support
truecolors() {
  awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
      s="/\\";
      for (colnum = 0; colnum<term_cols; colnum++) {
          r = 255-(colnum*255/term_cols);
          g = (colnum*510/term_cols);
          b = (colnum*255/term_cols);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum%2+1,1);
      }
      printf "\n";
  }'
}

# Yubikey reload. Will tell gpg-agent to update key ids when using multiple yubikeys with identical
# gpg keys.
# Run this when switching yubikey
ykr() {
  gpg-connect-agent "scd serialno" "learn --force" /bye
  echo UPDATESTARTUPTTY | gpg-connect-agent
}
