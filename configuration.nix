{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "AntColony"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # graphics support

  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics.enable = true;

  hardware.nvidia = {
  modesetting.enable = true;
  open = false;

  nvidiaSettings = true;

  prime = {
    offload.enable = true;

    amdgpuBusId = "PCI:5:0:0";

    nvidiaBusId = "PCI:1:0:0";
  };
  };


  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };


  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/Wallpapers/chinatown.png
      xset r rate 200 30 &
    '';
  };

  services.picom = {
    enable = true;
    backend = "glx";
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    extraSessionCommands = ''
      picom --experimental-backends --config /home/dracuxan/.config/picom/picom.conf &
    '';
  };
  programs.i3lock.enable = false;

  users.users.dracuxan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    clang-tools
    lua
    lua-language-server
    gopls
  ];

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    i3lock-color
    vim
    ruff
    lua
    pciutils
    rocmPackages.clang
    gcc
    go
    gopls
    rustup
    zig
    python314
    wget
    git
    autorandr
    tmux
    unzip
    gh
    gnumake
    pcmanfm
    stow	
    lazygit
    bat
    nodejs_24
    glibc
    stdmanpages
    man-pages
    man-db
    scrcpy
    android-tools
  ];

  fonts.packages = [
           pkgs.nerd-fonts._0xproto
           pkgs.nerd-fonts.droid-sans-mono
           pkgs.nerd-fonts.fira-code
         ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # services.openssh.enable = true;


  system.stateVersion = "25.05"; # Did you read the comment?

}

