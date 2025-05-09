{ config, pkgs, ... }:

{
  home.username = "beru";
  home.homeDirectory = "/home/beru";

  home.stateVersion = "24.11"; 

  home.packages = with pkgs; [ 
    neovim
    alacritty
    kitty
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
    kdePackages.falkon
    tmux
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
