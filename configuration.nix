{
  config,
  pkgs,
  ...
}: let
  zen-browser = import (builtins.fetchTarball {
    url = "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz";
  }) {inherit pkgs;};
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./home.nix
  ];

  networking.hostName = "nixos";
  system.stateVersion = "25.05";

  users.users.fbruggem = {
    isNormalUser = true;
    description = "fbruggem";
    extraGroups = ["input" "uinput" "networkmanager" "wheel"];
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Apps
    ghostty
    discord
    spotify
    obsidian
    (import (builtins.fetchTarball {
      url = "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz";
    }) {inherit pkgs;}).default

    # neovim
    neovim
    fzf
    ripgrep
    xclip
    clang

    # man pages
    man-pages
    alejandra
  ];

  # Gnome
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # to see all possible settings type in
  # gsettings list-schemas
  # for all groups and
  # gsettings list-keys SCHEMA_NAME
  # to get the keys
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
          };
          "org/gnome/desktop/wm/keybindings" = {
            "switch-to-workspace-1" = ["<Alt>1"];
            "switch-to-workspace-2" = ["<Alt>2"];
            "switch-to-workspace-3" = ["<Alt>3"];
            "switch-to-workspace-4" = ["<Alt>4"];
            "switch-to-workspace-5" = ["<Alt>5"];
            "toggle-fullscreen" = ["<Super>f"];
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            "search" = ["<Control>space"];
          };
          "org/gnome/desktop/interface" = {
            enable-animations = false;
            "color-scheme" = "prefer-dark";
            "gtk-theme" = "Adwaita-dark";
          };
          "org/gnome/desktop/peripherals/mouse" = {
            natural-scroll = true;
          };
        };
        lockAll = true; # optional: enforce the settings strictly
      }
    ];
  };

  # Git
  programs.git = {
    enable = true;
    config = {
      user.name = "felixbrgm";
      user.email = "github.badly321@passinbox.com";
      pull.rebase = false;
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
