{
  config,
  pkgs,
  username,
  ...
}: let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "0q3lv288xlzxczh6lc5lcw0zj9qskvjw3pzsrgvdh8rl8ibyq75s";
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
      "~/.config/autostart/ghostty.desktop".source = ./dotfiles/xdg/xdg_ghostty;
      ".config/nvim" = {
        source = ./dotfiles/nvim;
        recursive = true;
      };
    };
  };
}
