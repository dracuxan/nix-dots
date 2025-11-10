{ config, pkgs, inputs, system, ... }:

{
  home.username = "dracuxan";
  home.homeDirectory = "/home/dracuxan";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fzf
    bat
    ripgrep
    perl
    silver-searcher
    universal-ctags
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
    http-server
    obs-studio
    uv
    acpi
    obsidian
    inputs.zen-browser.packages.${system}.default
  ];

  home.file = { };

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}
