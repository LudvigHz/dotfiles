# zsh prompt

autoload -Uz add-zsh-hook

VCS_SYMBOL_BRANCH=""
VCS_SYMBOL_AHEAD="" # FIXME arrow up broken
VCS_SYMBOL_BEHIND="ﰬ"
VCS_SYMBOL_STAGED='●'
VCS_SYMBOL_CONFLICTS=""
VCS_SYMBOL_UNSTAGED=""
VCS_SYMBOL_UNTRACKED=""
VCS_SYMBOL_STASHED=""
VCS_SYMBOL_CLEAN='✔'

# git info
vcs_prompt_info() {
  # check if in git directory
  if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then

    # set all variables
    VCS_INFO_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    _VCS_INFO_COMMIT_STATUS=$(git for-each-ref --format="%(push:track)" refs/heads/$VCS_INFO_BRANCH | awk '{gsub(/\[|]|,/,""); print}')
    _VCS_INFO_STATUS=$(git status --porcelain 2> /dev/null)

    VCS_INFO_AHEAD=$(echo $_VCS_INFO_COMMIT_STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="ahead") print $(i+1)}')
    VCS_INFO_BEHIND=$(echo $_VCS_INFO_COMMIT_STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="behind") print $(i+1)}')
    VCS_INFO_STAGED=$(git diff --cached --numstat 2> /dev/null | wc -l)
    VCS_INFO_UNSTAGED=$(git diff --name-status 2> /dev/null | wc -l)
    VCS_INFO_UNTRACKED=$(echo "${_VCS_INFO_STATUS}" | grep "^??" | wc -l)
    VCS_INFO_CONFLICTS=$(git ls-files --unmerged 2> /dev/null | wc -l)
    VCS_INFO_STASHED=$(git rev-list --walk-reflogs --count refs/stash 2> /dev/null)


    # add indicators to prompt
    VCS_INFO="%F{green}${VCS_SYMBOL_BRANCH} %F{cyan}${VCS_INFO_BRANCH}%f "

    if [ ! -z "$VCS_INFO_AHEAD" ]; then
      VCS_INFO+="${VCS_SYMBOL_AHEAD} ${VCS_INFO_AHEAD} "
    fi

    if [ ! -z "$VCS_INFO_BEHIND" ]; then
      VCS_INFO+="${VCS_SYMBOL_BEHIND} ${VCS_INFO_BEHIND} "
    fi

    if [ "$VCS_INFO_STAGED" -ne "+0" ]; then
      VCS_INFO+="%F{green}${VCS_SYMBOL_STAGED} ${VCS_INFO_STAGED}%f "
    fi

    if [ "$VCS_INFO_UNSTAGED" -ne "+0" ]; then
      VCS_INFO+="%F{yellow}${VCS_SYMBOL_UNSTAGED} ${VCS_INFO_UNSTAGED}%f "
    fi

    if [ "$VCS_INFO_UNTRACKED" -ne "+0" ]; then
      VCS_INFO+="%F{red}${VCS_SYMBOL_UNTRACKED} ${VCS_INFO_UNTRACKED}%f "
    fi

    if [ "$VCS_INFO_STASHED" -ne "0" ]; then
      VCS_INFO+="%F{blue}${VCS_SYMBOL_STASHED} ${VCS_INFO_STASHED}%f "
    fi

    if [ "$VCS_INFO_CONFLICTS" -ne "+0" ]; then
      VCS_INFO+="%F{red}${VCS_SYMBOL_CONFLICTS} ${VCS_INFO_CONFLICTS}%f "
    fi

    if [ -z "${_VCS_INFO_STATUS}" ]; then
      VCS_INFO+="%F{green}${VCS_SYMBOL_CLEAN}%f"
    fi

    echo $VCS_INFO
  else
    echo ""
  fi
}


# Virtual env indicator
export VIRTUAL_ENV_DISABLE_PROMPT=yes

function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        psvar[1]=''
    else
        psvar[1]=${VIRTUAL_ENV##*/}
    fi
}

add-zsh-hook precmd virtenv_indicator


# Finalized prompt
precmd() {
    PS1="%(1V.(%1v).)%f%(1j.%F{cyan}[%j]%f .)%F{blue}ﬦ %~%f "   # start of promt: ﬦ ~
    PS1+="$(vcs_prompt_info)"                                          # git info
    PS1+=$'\n%(?.%F{green}.%F{red})  %f'                         # input line
}
