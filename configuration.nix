{
  config,
  pkgs,
  ...
}: let
  zen =
    (import (builtins.fetchTarball {
      url = "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz";
      sha256 = "1bw0k6q1snq1lrfayi7c3sn5m3kd4djh35zaz8zp5fcj180dzncy";
    }) {inherit pkgs;}).default;

  username = "fbruggem";
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import ./home.nix {inherit config pkgs username;})
  ];

  networking.hostName = "nixos";
  system.stateVersion = "25.05";

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Apps
    ghostty
    zen
    discord
    spotify
    obsidian
    vscode

    # neovim
    neovim
    fzf
    ripgrep
    xclip
    clang-tools
    cargo
    tree-sitter
    nodejs
    htop

    man-pages
    alejandra
  ];

  virtualisation.docker.enable = true;

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
            "enable-hot-corners" = false;
          };
          "org/gnome/desktop/wm/keybindings" = {
            "switch-to-workspace-1" = ["<Alt>1"];
            "switch-to-workspace-2" = ["<Alt>2"];
            "switch-to-workspace-3" = ["<Alt>3"];
            "switch-to-workspace-4" = ["<Alt>4"];
            "toggle-fullscreen" = ["<Super>f"];
          };
          "org/gnome/desktop/wm/preferences" = {
            "num-workspaces" = pkgs.lib.gvariant.mkInt32 4;
          };
          "org/gnome/mutter" = {
            "dynamic-workspaces" = false;
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
      user.name = "fbruggem";
      user.email = "fbruggem@proton.me";
      pull.rebase = false;
    };
  };

  nix.gc.automatic = true;
  nix.gc.dates = "05:00";
  nix.gc.options = "--delete-older-than 3d";
  nix.settings.auto-optimise-store = true;

  # This upgrades packages and nixos - pulling in minor changes or security updates
  # Because the time is set to daily at 06:00 during which time its most likely off
  # it will _catch up_ one the first reboot of the day. If the kernel needs updating it
  # reboots - this forces the newest updates everyday from the start BUT without rebooting
  # when you are activly working on something
  system.autoUpgrade = {
    enable = true;
    flags = ["-I" "nixos-config=/home/fbruggem/nixos/configuration.nix"];
    persistent = true;
    dates = "06:00";
    allowReboot = true;
  };

  # Automatic checking of new changes of the config on github and rebuild if there is a new commit
  systemd.timers.nixos-config-rebuild = {
    description = "Run nixos-config-update hourly";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*:0/1"; # every minute
      Persistent = true; # catch up if missed
    };
  };

  systemd.services.nixos-config-pull = {
    description = "Update NixOS config repository";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/home/${username}/nixos"; # adjust this path to where your git repo is
      ExecStart = pkgs.writeShellScript "nixos-config-pull" ''
        set -euo pipefail
        export HOME=/home/${username}
        cd /home/${username}/nixos
        echo "[nixos-config-pull] fetching..."
        ${pkgs.git}/bin/git fetch origin
        # count commits on remote that are not in local
        remoteAheadCount=$(${pkgs.git}/bin/git rev-list HEAD..@{u} --count)
        if [ "$remoteAheadCount" -gt 0 ]; then
          echo "[nixos-config-pull] remote ahead by $remoteAheadCount, pulling..."
          ${pkgs.git}/bin/git pull --ff-only
          echo "[nixos-config-pull] pull done — signaling updated (exit 42)"
          exit 0
        else
          echo "[nixos-config-pull] already up-to-date"
          exit 1
        fi
      '';
      User = "${username}"; # or another user if your repo isn’t root-owned
      Environment = [
        "PATH=${pkgs.git}/bin:${pkgs.openssh}/bin"
        "HOME=/home/${username}" # <--- so git+ssh sees ~/.ssh
      ];
    };
  };

  systemd.services.nixos-config-rebuild = {
    description = "Rebuild NixOS if pull updated the repo";
    unitConfig = {
      Requires = ["nixos-config-pull.service"];
      After = ["nixos-config-pull.service"];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "nixos-config-rebuild" ''
        # Once one command fails the script stops
        set -euo pipefail
        # Rebuild
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch \
        --upgrade \
        -I nixos-config=/home/${username}/nixos/configuration.nix \
        -I nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos
      '';
      # run as root (default), so we don't set User
      Environment = [
        "PATH=${pkgs.nix}/bin:${pkgs.nixos-rebuild}/bin:${pkgs.git}/bin:${pkgs.openssh}/bin:${pkgs.bash}/bin"
      ];
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["input" "uinput" "networkmanager" "wheel" "docker"];
  };

  # Gnome
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
