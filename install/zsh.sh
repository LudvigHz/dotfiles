#!bin/bash

# set DOTFILES to current directory
DOTFILES="$( pwd )"

ZSH_PLUGINS=$DOTFILES/zsh_plugins

git_clone() {
  if [[ ! -d "$2" ]]; then
    git clone $1 $2
  fi
}


add_if_not_present() {
  grep -Fxq "$1" "$2" || echo "$1" >> "$2"
}

echo "source $DOTFILES/.local" > ~/.zshrc


echo "export DOTFILES=$DOTFILES" > $DOTFILES/.local


echo "export ZSH_PLUGINS=$ZSH_PLUGINS" >> $DOTFILES/.local
echo "source $DOTFILES/zshrc" >> $DOTFILES/.local

echo "Cloning and setting up dependencies"
git_clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGINS/zsh-autosuggestions
git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting
git_clone https://github.com/zsh-users/zsh-completions.git $ZSH_PLUGINS/zsh-completions
git_clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_PLUGINS/zsh-history-substring-search
git_clone https://github.com/b4b4r07/enhancd $ZSH_PLUGINS/enhancd
git_clone https://github.com/LudvigHz/k $ZSH_PLUGINS/k
