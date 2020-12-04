# Run tmux if exists
if command -v tmux>/dev/null; then
  [ -z $TMUX ] && exec tmux
else
  echo "tmux not installed on this system"
fi

# zmodload zsh/zprof

# various zsh options
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Turn off stupid beep!
unsetopt BEEP


# ---------------------------------------------------------
# history
# ---------------------------------------------------------

HISTFILE=$DOTFILES/.local/zsh_history
SAVEHIST=100000
HISTSIZE=100000
setopt INC_APPEND_HISTORY
setopt histignoredups
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }



# ---------------------------------------------------------
# Plugins
# ---------------------------------------------------------

# If on debian and autojump installed, source the provided
# shell script.
if [ -f "/etc/debian_version" ]; then
  [ -x $(command -v autojump) ] && . /usr/share/autojump/autojump.sh
elif [[ "$OSTYPE" == "darwin"* ]] then
  [ -x $(command -v autojump) ] && . /usr/local/share/autojump/autojump.zsh
fi

# Source FZF if installed
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# use ripgrep for fzf
# Respect gitignores and always ignore module directories
export FZF_DEFAULT_COMMAND="rg --files --follow --ignore-vcs -g '!{node_modules,venv}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#Plugins
source_plugin() {
  local source_file="$1.plugin.zsh"
  # Use second argument as filename if provided
  if [[ ! -z $2 ]]; then
    source_file=$2
  fi
  [[ -d $ZSH_PLUGINS/$1 ]] && source "$ZSH_PLUGINS/$1/$source_file"
}


# Place github path for plugins to be installed here.
plugins=(
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
  "zsh-users/zsh-completions"
  "zsh-users/zsh-history-substring-search"
  "LudvigHz/k"
)

# Oh-my-zsh plugins to be installed
oh_my_zsh_plugins=(
  "sudo"
  "dotenv"
)


# To source the plugins above, use the source_plugin command
# if the filename is different from <plugin>.plugin.zsh
# use second argument as filename.
source_plugin zsh-autosuggestions
source_plugin zsh-syntax-highlighting
source_plugin zsh-completions
source_plugin zsh-history-substring-search
source_plugin k "k.sh"
source_plugin sudo
source_plugin dotenv


# ---------------------------------------------------------
# Path
# ---------------------------------------------------------

export PATH="$HOME/.yarn/bin:$HOME/go/bin:/usr/local/go/bin:/usr/local/texlive/2020/bin/x86_64-linux:/home/ludvig/.local/share/coursier/bin:$PATH"


# ---------------------------------------------------------
# Prompt
# ---------------------------------------------------------

source $DOTFILES/prompt.zsh



# ---------------------------------------------------------
# Aliases
# ---------------------------------------------------------

alias ..="cd ../"


# Git
alias gd="git diff"
alias gs="git status"
alias ga="git add ."
alias gc="git checkout"
alias gcm="git checkout master"

# GitHub
alias ghc="gh pr checkout"

# Programs
alias gotop="gotop --color=monokai -p -b"
[ $(command -v ccat) ] && alias cat='ccat -G Keyword="darkgreen" -G Type="darkblue" -G Punctuation="lightgray" -G Plaintext="reset" -G Comment="darkgray"'
alias ocat="cat"

# Open modified files
# ACMR = Added || Copied || Modified || Renamed
alias vd="vim \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="vim \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vdc="vim \$(git diff HEAD^ --name-only --diff-filter=tm)"


# Clipboard
# $<some command> | copy
alias copy="xclip -sel clip"

# XDG open
alias fm="xdg-open ." # Open file manager


# Asciinema to GIF
alias asciicast2gif="docker run --rm -v $(pwd):/data asciinema/asciicast2gif"


# Ansible
alias av="ansible-vault"
alias ap="ansible-playbook"


# Sudo vim
alias svim="sudoedit"

# ---------------------------------------------------------
# Functions
# ---------------------------------------------------------

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


# ---------------------------------------------------------
# Compinit (Completion initialization)
# ---------------------------------------------------------

# Completions not provided by plugins or bundled can be put here
fpath=("$DOTFILES/.local/completions" $fpath)

_zpcompinit_custom() {
  # Remember to have "skip_global_compinit=1" in $ZDOTDIR:-$HOME/.zshenv
  # otherwise zsh calls compinit by itself and generates a new dumpfile,
  # ruining the whole point of the cache...

  setopt extendedglob local_options
  autoload -Uz compinit
  local zcd=${ZDOTDIR:-$HOME}/.zcompdump
  local zcdc="$zcd.zwc"
  # If the completion dump is older than 24h
  if [[ -f "$zcd"(#qN.m+1) ]]; then
    compinit -i -d "$zcd" # Run compinit and specify compdump to $zcd
    compdump              # Force call compdump (should not be neccasary)
    { rm -f "$zcdc" && zcompile "$zcd" } &!   # Remove and recompile
  else
    compinit -C "$zcd"    # Only check the cache usually
  fi
  unsetopt extendedglob
}

_zpcompinit_custom


# Reload completions. Useful for loading new completions.
# Otherwise they are not loaded until the next day
compload() {
  setopt extendedglob local_options
  local zcd=${ZDOTDIR:-$HOME}/.zcompdump
  local zcdc="$zcd.zwc"
  rm -f "$zcdc" "$zcd"
  _zpcompinit_custom
}

# Call zprof (debug)
#zprof
#
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
