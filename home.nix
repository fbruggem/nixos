{
  config,
  pkgs,
  ...
}: let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "0d41gr0c89a4y4lllzdgmbm54h9kn9fjnmavwpgw0w9xwqwnzpax";
  };
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.fbruggem = {
    home.stateVersion = "25.05";
    home.file = {
      ".config/ghostty/config".source = ./config/ghostty;
      ".bashrc".source = ./config/bashrc;
      ".config/gdb/gdbinit".source = ./config/gdbinit;
      ".config/nvim" = {
        source = ./config/nvim;
        recursive = true;
      };
    };
  };
}
