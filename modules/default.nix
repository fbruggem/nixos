# Aggregates every system module. `./modules` in flake.nix resolves here.
{...}: {
  imports = [
    ./system.nix
    ./packages.nix
    ./home.nix
  ];
}
