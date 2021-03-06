<p align="center">
  <h1 align="center" style="text-decoration: underline;">LudvigHz dotfiles</h1>
</p>

<p align="center">
  <img src="./screenshots/arch-desktop.png" />
</p>

**Dotfiles used on (currently) Arch Linux for the following:**

- Xresources (Used for [urxvt](https://wiki.archlinux.org/index.php/Rxvt-unicode))
- [Vim](http://vim.org)
- [zsh](http://zsh.sourceforge.net)
- [Alacritty](https://github.com/jwilm/alacritty)
- [zathura](https://git.pwmt.org/pwmt/zathura)
- [tmux](https://github.com/tmux/tmux)

## Installation

> Make sure to install Nerdfonts: https://github.com/ryanoasis/nerd-fonts

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

`./install.sh tmux` to install.

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

> This only installs the configuration

```sh
./install.sh zsh
```

#### Updating

To update zsh plugins, run:

```sh
./install.sh zsh-update # in dotfiles folder
# Or
dots zsh-update # From anywhere
```

This will also install any new plugins defined in `zshrc`

> Currently does not support updates from oh-my-zsh plugins

#### Completion

There is a bit of custom logic for shell completion. See `zshrc` for detail. By default, zsh
compiles and loads completions on every new shell startup. This is slow and annoying, so it is
configured to load once every day.

To reload new completions, f.ex. when installing new programs or
adding completion files, run the provided command:

```sh
# Reload completions
$ compload
```

##### Custom completions

Many programs provide completions by generating this with a command. This must be put in its own
file in `$DOTFILES/.local/completions` to be loaded.
**Example**

```sh
kubectl completion zsh > $DOTFILES/.local/completions/_kubectl
```

## Vim

> Same installation as with fzf, use cli-tools script to install both vim and neovim

```sh
./install.sh vim
```

Run `:PlugInstall` if it doesn't install automatically when you open vim.

- Note: npm and node.js is required for coc.nvim.

#### Completion

This config currently uses coc.nvim for completion.
See [here](https://github.com/neoclide/coc.nvim/wiki/Language-servers) for configuration of language
servers.

## Screens

<p align="center">
  <img width="600" src="./screenshots/vim-js.png" />
</p>

## Gnome configuration

Make sure to have gnome-tweaks installed and run:

```sh
cd ~
dconf load / < dotfiles/ubuntu/saved_settings.dconf
```
