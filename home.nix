{ config, pkgs, ... }:

{
  home.username = "beru";
  home.homeDirectory = "/home/beru";

  home.stateVersion = "24.11"; 

  home.packages = with pkgs; [ 
    ruff
    lua
    kdePackages.falkon
  ];

  home.file = {
    ".config/starship.toml" = {
      source = ./starship/starship.toml;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/qtile" = {
      source = ./qtile;
      recursive = true;
    };
    ".config/alacritty" = {
      source = ./alacritty;
      recursive = true;
    };
    ".zshrc" = {
      source = ./zsh/.zshrc;
      recursive = true;
    };
    ".config/fastfetch" = {
      source = ./fastfetch;
      recursive = true;
    };
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
