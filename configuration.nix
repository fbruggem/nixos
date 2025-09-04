{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  networking.hostName = "nixos";
  system.stateVersion = "25.05";

  users.users.fbruggem = {
    isNormalUser = true;
    description = "fbruggem";
    extraGroups = [ "input" "uinput" "networkmanager" "wheel" ];
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
	  # Apps
    ghostty
    firefox
    discord
    spotify

    # neovim
    neovim
    fzf
    ripgrep
    xclip
    clang

    # man pages
    man-pages
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

  programs.git = {
    enable = true;
    config = {
      user.name = "felixbrgm";
      user.email = "github.badly321@passinbox.com";
    };
  };


  system.activationScripts.ghosttyConfig = {
    text = ''
      mkdir -p /home/fbruggem/.config/ghostty
      rm -f  /home/fbruggem/.config/ghostty/config
      echo "font-size = 12" >> /home/fbruggem/.config/ghostty/config
      echo "keybind = control+.=toggle_split_zoom" >> /home/fbruggem/.config/ghostty/config
      echo "keybind = ctrl+,=goto_split:next" >> /home/fbruggem/.config/ghostty/config
      echo "keybind = super+,=new_split:right" >> /home/fbruggem/.config/ghostty/config
      echo "keybind = super+shift+,=new_split:down" >> /home/fbruggem/.config/ghostty/config
      echo "keybind = super+ctrl+shift+left=resize_split:left,25" >> /home/fbruggem/.config/ghostty/config
      echo "keybind = super+ctrl+shift+right=resize_split:right,25" >> /home/fbruggem/.config/ghostty/config
    '';
  };

  system.activationScripts.gdb = {
    text = ''
      mkdir -p /home/fbruggem/.config/gdb
      echo "set auto-load safe-path /" > /home/fbruggem/.config/gdb/gdbinit
    '';
  };

  system.activationScripts.lazyvim = {
    text = ''
      
      ln -sfn /etc/nixos/nvim /home/fbruggem/.config/nvim || true
    '';
  };

  system.activationScripts.bashrc = {
    text = ''
      rm -f  /home/fbruggem/.bashrc
      echo 'export PS1="\W> "' >> /home/fbruggem/.bashrc
      echo 'set -o vi' >> /home/fbruggem/.bashrc
      echo 'alias vim="nvim"' >> /home/fbruggem/.bashrc
    '';
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
