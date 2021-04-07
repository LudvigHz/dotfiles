# General
alias ..="cd ../"

# Git
alias gd="git diff"
alias gs="git status"
alias ga="git add ."
alias gc="git checkout"
alias gcm="git checkout master"

# Programs
alias gotop="gotop --color=monokai -p -b"
[ $(command -v bat) ] && alias cat='bat'

# Open modified files
# ACMR = Added || Copied || Modified || Renamed
alias vd="vim \$(git diff HEAD --name-only --diff-filter=ACMR)"
alias vds="vim \$(git diff --staged --name-only --diff-filter=ACMR)"
alias vdc="vim \$(git diff HEAD^ --name-only --diff-filter=tm)"

# Clipboard
# $<some command> | copy
alias copy="xclip -sel clip"

# XDG open
alias o=xdg-open

# Asciinema to GIF
alias asciicast2gif="docker run --rm -v $(pwd):/data asciinema/asciicast2gif"

# Ansible
alias av="ansible-vault"
alias ap="ansible-playbook"

# Sudo vim
alias svim="sudoedit"
