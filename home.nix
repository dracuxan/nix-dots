{ config, pkgs, inputs, system, ... }:

{
  home.username = "dracuxan";
  home.homeDirectory = "/home/dracuxan";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    neovim
    alacritty
    starship
    fastfetch
    lazygit
    gh
    stow
    feh
    btop
    xwallpaper
    flameshot
    xorg.xrandr
    tmux
    dysk
    tokei
    bear
    traceroute
    glibc.dev
    inputs.zen-browser.packages.${system}.default
  ];

  home.file = { };

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}

