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

export PATH="$HOME/.yarn/bin:$HOME/go/bin:/usr/local/go/bin:/usr/local/texlive/2020/bin/x86_64-linux:/home/ludvig/.local/share/coursier/bin:$HOME/.cabal/bin:$PATH"


# ---------------------------------------------------------
# Environment
# ---------------------------------------------------------
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

export LESS='-+F -+S -+X -c'

# launch gpg-agent with ssh support
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# use ripgrep for fzf
# Respect gitignores and always ignore module directories
export FZF_DEFAULT_COMMAND="rg --files --follow --ignore-vcs -g '!{node_modules,venv}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# ---------------------------------------------------------
# Prompt
# ---------------------------------------------------------

source $DOTFILES/prompt.zsh


# ---------------------------------------------------------
# Aliases
# ---------------------------------------------------------
source $DOTFILES/aliases.zsh


# ---------------------------------------------------------
# Functions
# ---------------------------------------------------------
source $DOTFILES/functions.zsh


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
