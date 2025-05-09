{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "AntColony"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/Wallpaper/anime_skull.png
      xset r rate 300 30 &
    '';
  };
  
  services.picom = {
    enable = true;
  };
  
  users.users.beru = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    ruff
    lua
    nodejs
  ];


  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    unzip
    gnumake
    wget
    go
    clang
    gcc
    python3Full
    zig
    nodejs
    ruff
    lua
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];


  system.stateVersion = "24.11"; # Did you read the comment?

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };
}

