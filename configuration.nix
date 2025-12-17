{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "AntColony";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "ignore";

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

  # Game setup

  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;

  # programs.gamemode.enable = true;

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

  systemd.sleep.extraConfig = ''
  AllowSuspend=no
  AllowHibernation=no
  AllowHybridSleep=no
  AllowSuspendThenHibernate=no
'';

  # Postgres setup
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sessionCommands = ''
      set_wallpaper.sh
      xset r rate 200 30 &
    '';
  };

  services.picom = {
    enable = true;
    backend = "glx";

    activeOpacity = 0.9;
    inactiveOpacity = 0.9;

    settings = {
      blur-method = "dual_kawase";
      blur-strength = 8;

      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'i3bar'"
      ];
    };
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    extraSessionCommands = ''
      picom &
    '';
  };

  programs.niri.enable = true;

  users.users.dracuxan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
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
    mangohud
    tcpdump
    vim
    ruff
    lua
    pciutils
    rocmPackages.clang
    gcc
    go
    opam
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
    sioyek
    libxcvt
    cmus
    cava
    metasploit
    gn
    ninja
    bun
    quickshell
    niri
    zoxide
    unixtools.arp
    elixir
    erlang
    elixir-ls
    inotify-tools
    ffmpeg
  ];

   fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    symbola
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
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

