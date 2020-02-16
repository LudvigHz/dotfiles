# Dotfiles

Dotfiles used on Pop!\_OS 19.04 for the following:

- Xresources (Used for [urxvt](https://wiki.archlinux.org/index.php/Rxvt-unicode))
- [Vim](http://vim.org)
- [zsh](http://zsh.sourceforge.net)
- [Alacritty](https://github.com/jwilm/alacritty)
- [zathura](https://git.pwmt.org/pwmt/zathura)
- [tmux](https://github.com/tmux/tmux)

Make sure to install Nerdfonts: https://github.com/ryanoasis/nerd-fonts

## Installation

The configration uses an install utility, run the utility to see what can be auto-installed.

```sh
chmod +x install.sh
./install.sh
```

To Install everything automatically, run the install utility with `-a`:

```sh
./install.sh -a
```

## Tmux

`bash install.sh cli-tools -n tmux` to install.

## ZSH

#### Fzf

- Both zsh and vim configration uses fzf.
- Note: fzf commands in zsh uses ripgrep instead of grep for optimal performance.
  use the utility to install it as well.

- Installation

```sh
./install.sh cli-tools -n fzf
./install.sh cli-tools -n ripgrep
```

#### Installation

Install with the provided utility with `zsh` as argument:

> This only installs the configration, to install the actual program, use the cli-tools script

```sh
./install.sh zsh
```

#### Updating

To update zsh plugins, run:

```sh
./install.sh zsh-update
```

This will also install any new plugins defined in `zshrc`

> Currently does not support updates from oh-my-zsh plugins

## Vim

> Same installation as with fzf, use cli-tools script to install both vim and neovim

```sh
./install.sh vim
```

Run `:PlugInstall` if it doesn't install automatically when you open vim.

- Note: npm and node.js is required for coc.nvim. If it is not installed, run:
  `sudo apt-get install nodejs` and `sudo apt-get install npm`

#### Completion

This config currently uses coc.nvim for completion.
See [here](https://github.com/neoclide/coc.nvim/wiki/Language-servers) for configuration of language
servers.

## Screens

![zsh alacritty](screenshots/zsh-alacritty.png?raw=true)

![vim_coc autocompletion](screenshots/vim-coc.png?raw=true)

## Gnome configuration

Make sure to have gnome-tweaks installed and run:

```sh
cd ~
dconf load / < dotfiles/ubuntu/saved_settings.dconf
```
