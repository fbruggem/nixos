# Aggregates every system module. `./modules` in flake.nix resolves here.
{...}: {
  imports = [
    ../modules/packages.nix
    ../modules/home.nix
    ../modules/flatpak.nix
    ../modules/easyeffects.nix
    ../modules/system.nix
    ../modules/gnome.nix
    ../modules/gaming.nix
  ];
}
