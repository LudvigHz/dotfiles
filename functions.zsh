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

psp() {
  pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
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


# GitHub
ghc() {
  # Original author: Sebastian Jambor (https://github.com/sgrj)
  # Original source retrieved from: https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/

  local jq_template pr_number

  jq_template='"'\
'#\(.number) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  if [ -n "$1" ]; then
    pr_number="$1"
  else
    pr_number="$(
    gh api 'repos/:owner/:repo/pulls' |
      jq ".[] | $jq_template" |
      sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
      fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
      sed 's/^#\([0-9]\+\).*/\1/'
    )"
  fi

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}


dotcomp() {
  _dotnet_zsh_complete()
  {
    local completions=("$(dotnet complete "$words")")

    reply=( "${(ps:\n:)completions}" )
  }

  compctl -K _dotnet_zsh_complete dotnet
}

