# NixOS Flake Dotfiles Setup

> **⚠️ WARNING**: This is a personal configuration. Everything is FAFO - use at your own risk.

This repo contains my NixOS system and Home Manager configurations using flakes for hostname "AntColony".

> **⚠️ WARNING**: These configs assume NVIDIA GPU, specific hardware, and may break on different setups.

## Prerequisites (after a fresh NixOS install)

### Enable flakes and nix-command

Add to `/etc/nixos/configuration.nix`:

```nix
nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
};
```

Then apply using:

```bash
sudo nixos-rebuild switch
```

## Installation

1. Clone the repo:

```bash
git clone https://github.com/dracuxan/nix-dots.git ~/nix-dots && cd ~/nix-dots
```

2. Run installation script to stow configs:

```bash
make install
```

3. Apply NixOS configuration:

```bash
make build
```

## Available Commands

```bash
make build    # Apply NixOS configuration
make update   # Update flake inputs
make clean    # Clean up old generations
make install  # Stow configuration files
```

## Configured Tools

- **i3** - Tiling window manager
- **alacritty** - Terminal emulator
- **nvim** - Neovim with LSP and plugins
- **zsh** - Shell with aliases and vim keybindings
- **tmux** - Terminal multiplexer
- **picom** - Compositor with blur
- **fastfetch** - System information

## Screenshots

### i3 Window Manager

![i3_wm](./Screenshots/i3_wm.png)

### Alacritty Terminal

![Alacritty](./Screenshots/alacritty.png)

### Neovim

![Neovim](./Screenshots/nvim.png)

## Folder Structure

```
nix-dots/
├── alacritty/           # Terminal config
├── fastfetch/          # System info config
├── i3/                 # Window manager config
├── i3status/           # Status bar config
├── nvim/               # Neovim config and plugins
├── picom/              # Compositor config
├── scripts/            # Utility scripts
├── tmux/               # Terminal multiplexer config
├── zsh/                # Shell configuration
├── flake.lock          # Dependency lock file
├── flake.nix           # Main flake config
├── home.nix            # Home manager config
├── configuration.nix   # NixOS system config
├── Makefile            # Build commands
└── install.sh          # Installation script
```
