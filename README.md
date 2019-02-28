# Dotfiles
Dotfiles for zsh, tmux and vim used on linux - Ubuntu 18.10

Make sure to install Nerdfonts: https://github.com/ryanoasis/nerd-fonts

Also install iconpacks which is used in zsh config: https://github.com/ryanoasis/nerd-fonts#icon-names-in-shell

## Tmux
`sudo apt-get install tmux` to install. Then put `source ~/dotfiles/.tmux.conf` in `.tmux.conf` in home folder.


## ZSH
Put `source ~/dotfiles/.zshrc` in `.zshrc` in home folder.


#### Install zsh-vcs-info

https://github.com/yonchu/zsh-vcs-prompt
```sh
cd ~
mkdir .zsh && cd .zsh/
git clone https://github.com/yonchu/zsh-vcs-prompt
```

#### Fzf

https://github.com/junegunn/fzf
```sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

#### Install zplug
```sh
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
zplug install
```


## Vim
Put `so ~/dotfiles/.vimrc` in `.vimrc` in home folder.

Run `:PlugInstall` if it doesn't install automatically when you open vim.

#### YouCompleteMe
This configration uses https://github.com/Valloric/YouCompleteMe for auto-completion

For installation run:
```sh
sudo apt install build-essential cmake python3-dev

cd ~/.vim/plugged/youcompleteme
./install.py --clangd-completer --ts-completer
```
- Note: npm and node.js is required for javascript and typescript completion. If it is not installed, run:
`sudo apt-get install nodejs` and `sudo apt-get install npm`

- language flags are optional, see https://github.com/Valloric/YouCompleteMe#linux-64-bit for more info.

#### Ripgrep
https://github.com/BurntSushi/ripgrep

`sudo apt-get install ripgrep` to install. `:Rg <search pattern>` in vim to use.

## Screenhots

![zsh prompt](screenshots/zsh_prompt.png?raw=true)

![vim autocompletion](screenshots/vim_ycm.png?raw=true)

![vim ripgrep](screenshots/vim_rg.png?raw=true)


## Ubuntu configuration
Make sure to have gnome-tweaks installed and run:
```sh
cd ~
dconf load / < dotfiles/ubuntu/saved_settings.dconf
```
