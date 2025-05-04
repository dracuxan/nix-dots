{ config, pkgs, ... }:

{
  home.username = "beru";
  home.homeDirectory = "/home/beru";

  home.stateVersion = "24.11"; 

  home.packages = with pkgs; [ 
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
