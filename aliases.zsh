# General
alias ..="cd ../"
alias vim="nvim"

# Git
alias gd="git diff"
alias gs="git status"
alias ga="git add ."
alias gc="git checkout"
alias gcm="git checkout master"
alias gca="git commit --amend"
alias gp="git push"
alias gpf="git push --force-with-lease"

# Programs
alias gotop="gotop --color=monokai -p -b"
if [ $(command -v bat) ]; then
  alias cat='bat'
  alias catt='/usr/bin/cat'
fi

# Open modified files
# ACMR = Added || Copied || Modified || Renamed
# U = Unmerged (conflicting)
# TM = Changed || Modified
alias vd="vim \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="vim \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vda="vim \$(git diff HEAD^ --name-only --diff-filter=TM)"
alias vdc="vim \$(git diff --name-only --diff-filter=U)"

# Clipboard
# $<some command> | copy
alias copy="xclip -sel clip"

# Format json in clipboard
alias jsontidy="xclip -o | jq '.' | copy"

# XDG open
alias o=xdg-open

# Asciinema to GIF
alias asciicast2gif="docker run --rm -v $(pwd):/data asciinema/asciicast2gif"

# Ansible
alias av="ansible-vault"
alias ap="ansible-playbook"

# Sudo vim
alias svim="sudoedit"
