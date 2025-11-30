{
  config,
  pkgs,
  username,
  ...
}: let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "07pk5m6mxi666dclaxdwf7xrinifv01vvgxn49bjr8rsbh31syaq";
  };
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.${username} = {
    home.stateVersion = "25.05";
    home.file = {
      ".config/ghostty/config".source = ./dotfiles/ghostty;
      ".bashrc".source = ./dotfiles/bashrc;
      ".config/gdb/gdbinit".source = ./dotfiles/gdbinit;
      ".config/nvim" = {
        source = ./dotfiles/nvim;
        recursive = true;
      };
    };
  };
}
