# Aggregates every system module. `./modules` in flake.nix resolves here.
{...}: {
  imports = [
    ./packages.nix
    ./home.nix
    ./flatpak.nix
    ./easyeffects.nix
    ./system.nix
    ./desktop.nix
  ];
}
