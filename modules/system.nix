# Core system: boot, nix, users, networking, locale, time, git.
{
  pkgs,
  username,
  ...
}: {
  system.stateVersion = "26.05";
  networking.hostName = "thinkpad-t480s";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fix Elan touchpad/TrackPoint interval lag introduced by a BIOS/EC firmware
  # update (applied via Fedora's fwupd; persists in hardware, so it lags on any
  # OS). Both internal pointers share I2C client 0-0015 on the shared i801
  # SMBus that the EC also polls; the firmware change made that path stutter.
  # This forces the touchpad to stay in PS/2 mode instead of upgrading to SMBus,
  # bypassing the contended bus. A Bluetooth mouse is unaffected (separate USB
  # radio). Trade-off: PS/2 mode drops some high-res multitouch gestures.
  boot.kernelParams = ["psmouse.elantech_smbus=0"];

  # Networking
  networking.networkmanager.enable = true;

  # Nix daemon settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "12:00";
    options = "--delete-older-than 7d";
  };

  # Daily auto-upgrade FROM the flake on GitHub. This replaces the old
  # every-minute git-pull + rebuild timers. It rebuilds at 06:00 using
  # whatever is committed to main (and its flake.lock), catching up on the
  # next boot if the machine was off. To pull in new nixpkgs, run
  # `nix flake update` locally and push (or run ./rebuild.sh).
  system.autoUpgrade = {
    enable = true;
    flake = "github:fbruggem/nixos";
    dates = "06:00";
    persistent = true;
    allowReboot = false;
  };

  # Time & locale
  time.timeZone = "Europe/Vienna";
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

  # User
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["input" "uinput" "networkmanager" "wheel" "docker" "i2c"];
  };

  # System-wide git
  programs.git = {
    enable = true;
    config = {
      user.name = "fbruggem";
      user.email = "git@fbruggem.eu";
      pull.rebase = false;
    };
  };
}
