#!/usr/bin/env bash

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
for dir in alacritty fastfetch nvim i3 i3status picom fusuma; do
    mkdir -p "$HOME/.config/$dir"
done

echo "[+] Stowing configs into ~/.config..."

stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/alacritty" alacritty
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/fastfetch" fastfetch
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/nvim" nvim
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/i3" i3
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/i3status" i3status
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/picom" picom
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.config/fusuma" fusuma

echo "[+] Stowing legacy dotfiles into ~..."
stow --adopt -d "$DOTFILES_DIR" -t "$HOME" zsh
stow --adopt -d "$DOTFILES_DIR" -t "$HOME" tmux
stow --adopt -d "$DOTFILES_DIR" -t "$HOME/.local/bin" scripts

echo "[+] Checking wallpaper config..."
if [[ ! -f "$HOME/.config/wallpaper.conf" ]]; then
    mkdir -p "$HOME/.config"
    echo "# Wallpaper Configuration" > "$HOME/.config/wallpaper.conf"
    echo "WALLPAPER_PATH=~/Wallpapers/gruvbox_spac.jpg" >> "$HOME/.config/wallpaper.conf"
    echo "Created default wallpaper configuration"
fi

echo "-----------------------------------------"
echo "       Setup Complete — Reboot Now       "
echo "-----------------------------------------"
