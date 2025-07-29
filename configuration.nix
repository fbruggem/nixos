# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #  wget
programs.dconf = {
  enable = true;
  profiles.user.databases = [
    {
      settings = {
	"org/gnome/desktop/interface" = {
          enable-animations = false;
        };
        "org/gnome/desktop/wm/keybindings" = {
          "switch-to-workspace-1" = ["<Alt>1"];
          "switch-to-workspace-2" = ["<Alt>2"];
          "switch-to-workspace-3" = ["<Alt>3"];
          "switch-to-workspace-4" = ["<Alt>4"];
          "switch-to-workspace-5" = ["<Alt>5"];
          "search" = ["<Control>space"];
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
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fbruggem = {
    isNormalUser = true;
    description = "fbruggem";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfree = true;
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	# Apps
        ghostty
        firefox
        discord
        spotify
	# vim
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	# you will need this in you init.lua to work
	# local lspconfig = require("lspconfig")
	# lspconfig.clangd.setup({})
        neovim
        pkgs.vimPlugins.LazyVim
	vimPlugins.clangd_extensions-nvim
        fzf
	ripgrep
	# languages
	cargo
	binutils
	clang
	clang-tools
	glibc
	nasm
	# tools for coding
	valgrind
  ];

  system.activationScripts.createTestingFile = {
    text = ''
	rm -f  /home/fbruggem/.config/ghostty/config
	echo "font-size = 9" >> /home/fbruggem/.config/ghostty/config
	echo "keybind = ctrl+,=goto_split:next" >> /home/fbruggem/.config/ghostty/config
	echo "keybind = super+,=new_split:right" >> /home/fbruggem/.config/ghostty/config
	echo "keybind = super+shift+,=new_split:down" >> /home/fbruggem/.config/ghostty/config
	echo "keybind = super+ctrl+shift+left=resize_split:left,25" >> /home/fbruggem/.config/ghostty/config
	echo "keybind = super+ctrl+shift+right=resize_split:right,25" >> /home/fbruggem/.config/ghostty/config

    '';
  };
  system.activationScripts.bashrc = {
    text = ''
	rm -f  /home/fbruggem/.bashrc
	echo 'export PS1="\W> "' >> /home/fbruggem/.bashrc
	echo 'set -o vi' >> /home/fbruggem/.bashrc
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
