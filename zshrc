# Run tmux if exists
   if command -v tmux>/dev/null; then
       [ -z $TMUX ] && exec tmux
   else
       echo “tmux not installed on this system”
   fi

zmodload zsh/zprof # top of your .zshrc file

# various zsh options
zstyle ':completion:*' menu select

# Turn off stupid beep!
unsetopt BEEP

# Load colors
compinit colors




# ---------------------------------------------------------
# history
# ---------------------------------------------------------

HISTFILE=$DOTFILES/.local/zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt INC_APPEND_HISTORY
setopt histignoredups
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }



# ---------------------------------------------------------
# Plugins
# ---------------------------------------------------------

. /usr/share/autojump/autojump.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# use ripgrep for fzf
export FZF_DEFFAULT_COMMAND='rg --type f'

#Plugins
source_plugin() {
  local source_file="$1.plugin.zsh"
  # Use second argument as filename if provided
  if [[ ! -z $2 ]]; then
    source_file=$2
  fi
  [[ -d $ZSH_PLUGINS/$1 ]] && source $ZSH_PLUGINS/$1/$source_file
}


source_plugin zsh-autosuggestions
source_plugin zsh-syntax-highlighting
source_plugin zsh-completions
source_plugin zsh-history-substring-search
source_plugin enhancd "init.sh"
source_plugin k "k.sh"
source_plugin sudo



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


# Programs
alias gotop="gotop-cjbassi --color=monokai -p -b"
alias cat='ccat -G Keyword="darkgreen" -G Type="darkblue" -G Punctuation="lightgray" -G Plaintext="reset" -G Comment="darkgray"'


# Open modified files
# ACMR = Added || Copied || Modified || Renamed
alias v="vim"
alias vd="vim \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="vim \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vdc="vim \$(git diff HEAD^ --name-only --diff-filter=ACMR)"


# Clipboard
# $<some command> | copy
alias copy="xclip -sel clip"


# ---------------------------------------------------------
# Functions
# ---------------------------------------------------------

# Read MarkDown
rmd() {
  pandoc $1 | lynx -stdin
}


# Search and install from apt with fzf
# Optional argument to shorten search list
asp() {
  local inst=$(apt-cache search "${1:-.}" | eval "fzf -m --tac --header='[apt install]'")
  if [[ $inst ]]; then
    local name=$(echo $inst | head -n1 | awk '{print $1;}')
    echo $name
    if [[ ! -z "$(apt list --installed | grep $name)" ]]; then
      echo -e "\e[1m$name\e[0m is alredy installed: (u)pdate or (r)emove [ENTER to cancel]: \c"
      read option
      if [[ $option == "u" || $option == "U" ]]; then
        echo -e "\e[1mUpgrading: \e[1;94m$inst\e[0m \n"
        sudo apt upgrade $name
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






# Execute code in the background to not affect the current session
 {
   # Compile zcompdump, if modified, to increase startup speed.
   zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
     if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
       zcompile "$zcompdump"
     fi
} &!

#Load zplug
#zprof
