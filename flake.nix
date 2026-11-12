{
  description = "fbruggem's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # `follows` keeps home-manager on the SAME nixpkgs as the system,
    # so there's no version skew between the two.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    # flake.nix inputs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "fbruggem";
  in {
    nixosConfigurations.framework-13-pro = nixpkgs.lib.nixosSystem {
      inherit system;
      # specialArgs makes `inputs` and `username` available to every module.
      specialArgs = {inherit inputs username;};
      modules = [
        ./hardware-configurations/framework-13-pro.nix
        ./modules/desktop.nix
        ./modules/system.nix
        ./modules
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
        home-manager.nixosModules.home-manager
      ];
    };

    # `nix fmt` formats the whole repo.
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nix.settings.allow-unfree = true;
  };
}
