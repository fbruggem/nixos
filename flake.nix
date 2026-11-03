{
  description = "fbruggem's NixOS configuration";

  inputs = {
    # Track the 25.11 release. Bump this string to move releases.
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
    legacyPackages.${system} = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

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

    nixosConfigurations.head-less = nixpkgs.lib.nixosSystem {
      inherit system;
      # specialArgs makes `inputs` and `username` available to every module.
      specialArgs = {inherit inputs username;};
      modules = [
        ./hardware-configurations/framework-13-pro.nix
        ./modules/system.nix
        ./modules
        home-manager.nixosModules.home-manager
      ];
    };
    nixosConfigurations.thinkpad-t480s = nixpkgs.lib.nixosSystem {
      inherit system;
      # specialArgs makes `inputs` and `username` available to every module.
      specialArgs = {inherit inputs username;};
      modules = [
        ./hardware-configuration.nix
        ./modules/desktop.nix
        ./modules/system.nix
        ./modules
        home-manager.nixosModules.home-manager
      ];
    };

    nixosConfigurations.campus = nixpkgs.lib.nixosSystem {
      inherit system;
      # specialArgs makes `inputs` and `username` available to every module.
      specialArgs = {inherit inputs username;};
      modules = [
        ./hardware-configuration.nix
        ./modules/desktop.nix
        ./modules/system-campus.nix
        ./modules
        home-manager.nixosModules.home-manager
      ];
    };

    nixosConfigurations.hyprland-campus = nixpkgs.lib.nixosSystem {
      inherit system;
      # specialArgs makes `inputs` and `username` available to every module.
      specialArgs = {inherit inputs username;};
      modules = [
        ./hardware-configuration.nix
        ./modules/hyprland.nix
        ./modules/system-campus.nix
        ./modules
        home-manager.nixosModules.home-manager
      ];
    };

    templates.default = self.templates.rust;

    templates.rust = {
      path = ./templates/rust;
      description = "Per-project Rust devshell (fenix): pinned toolchain, rust-analyzer, direnv";
    };

    # `nix fmt` formats the whole repo.
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nix.settings.allow-unfree = true;
  };
}
