#!/bin/sh

set -e # Exit on error

echo "-----------------------------------------------------"
echo "       dracuxan's Dotfiles for NixOS Installer       "
echo "-----------------------------------------------------"

echo "[+] Checking stow..."
if command -v stow >/dev/null 2>&1; then
    echo "[+] exists"
else
    echo "[-] stow does not exist! Please install manually"
    exit 1
fi

echo "[+] Stowing dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Preparing ~/.config layout..."
for dir in alacritty fastfetch kitty nvim qtile; do
    mkdir -p "$HOME/.config/$dir"
done

echo "[+] Stowing configs into ~/.config..."

stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/alacritty" alacritty
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/fastfetch" fastfetch
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/kitty" kitty
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/nvim" nvim
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/qtile" qtile

echo "[+] Stowing legacy dotfiles into ~..."
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config" starship
stow --adopt -d "$DOTFILES_DIR" -t "$HOME" zsh

echo "-----------------------------------------"
echo "       Setup Complete — Reboot Now       "
echo "-----------------------------------------"
