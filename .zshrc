# Run tmux if exists
   if command -v tmux>/dev/null; then
       [ -z $TMUX ] && exec tmux
   else
       echo “tmux not installed on this system”
   fi


HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt INC_APPEND_HISTORY


# Turn off stupid beep!
unsetopt BEEP

# Load modules
autoload -Uz vcs_info
compinit colors

#Load plugins
. /usr/share/autojump/autojump.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#zplug plugins
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "b4b4r07/enhancd", use:init.sh
zplug "supercrabtree/k"
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/completion" from:oh-my-zsh
zplug "srijanshetty/zsh-pip-completion"



# Prompt

source ~/.local/share/fonts/i_dev.sh
source ~/.local/share/fonts/i_fa.sh
source ~/.local/share/fonts/i_oct.sh

source ~/.zsh/zsh-vcs-prompt/zshrc.sh
ZSH_VCS_PROMPT_ENABLE_CACHING='false'

ZSH_VCS_PROMPT_GIT_FORMATS='#c#d '
# Staged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{green}%}#e%{%f%b%}'
# Conflicts
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{red}%}#f%{%f%b%}'
# Unstaged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{yellow}%}#g%{%f%b%}'
# Untracked
ZSH_VCS_PROMPT_GIT_FORMATS+='#h'
# Stashed
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{cyan}%}#i%{%f%b%}'
# Clean
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{green}%}#j%{%f%b%}'


# Action
ZSH_VCS_PROMPT_GIT_ACTION_FORMAT+=':%{%B%F{red}%}#a%{%f%b%}'
# Ahead and Behind
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='#c#d '
# Staged
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{blue}%}#e%{%f%}'
# Conflicts
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{red}%}#f%{%f%}'
# Unstaged
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{yellow}%}#g%{%f%}'
# Untracked
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='#h'
# Stashed
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{cyan}%}#i%{%f%}'
# Clean
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{green}%}#j%{%f%}'



ZSH_VCS_PROMPT_AHEAD_SIGIL="${i_oct_cloud_upload} "
ZSH_VCS_PROMPT_BEHIND_SIGIL="${i_oct_cloud_download} "
ZSH_VCS_PROMPT_STAGED_SIGIL='● '
ZSH_VCS_PROMPT_CONFLICTS_SIGIL="${i_oct_x} "
ZSH_VCS_PROMPT_UNSTAGED_SIGIL="${i_oct_plus} "
ZSH_VCS_PROMPT_UNTRACKED_SIGIL="${i_dev_css_tricks} "
ZSH_VCS_PROMPT_STASHED_SIGIL="${i_oct_inbox} "
ZSH_VCS_PROMPT_CLEAN_SIGIL='✔ '



#zstyle ':vcs_info:*' stagedstr "%F{green}●%f "
#zstyle ':vcs_info:*' unstagedstr "%F{yellow}●%f "
#zstyle ':vcs_info:*' patch-format "%F{orange}%a%f"
#zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%F{green}${i_dev_git_branch} %f%F{gray}%b "


# Show active venv, if any

export VIRTUAL_ENV_DISABLE_PROMPT=yes

function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        psvar[1]=''
    else
        psvar[1]=${VIRTUAL_ENV##*/}
    fi
}

add-zsh-hook precmd virtenv_indicator



precmd() {
    vcs_info
    GLYPH="▲"
        [ "x$KEYMAP" = "xvicmd" ] && GLYPH="▼"

        PS1="%(1V.(%1v).) %(?.%F{blue}.%F{red})$GLYPH%f %(1j.%F{cyan}[%j]%f .)%F{blue}%~%f %(!.%F{red}#%f .)${vcs_info_msg_0_} $(vcs_super_info)
${i_fa_long_arrow_right}  "
    }


#Aliases

alias gd="git diff"
alias gs="git status"

alias gotop="gotop-cjbassi --color=monokai -p -b"


# Open modified files
# ACMR = Added || Copied || Modified || Renamed
alias v="vim"
alias vd="vim \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="vim \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vdc="vim \$(git diff HEAD^ --name-only --diff-filter=ACMR)"

#Load zplug
zplug load
