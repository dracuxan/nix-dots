#!/bin/sh

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/nvim" nvim
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/qtile" qtile
