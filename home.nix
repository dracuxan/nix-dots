{ config, pkgs, ... }:

{
  home.username = "beru";
  home.homeDirectory = "/home/beru";

  home.stateVersion = "24.11"; 

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
    rofi
    flameshot
    xorg.xrandr
    tmux
    librewolf
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
