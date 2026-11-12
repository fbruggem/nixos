# nixos

Flakes-based NixOS configuration.

## Layout

```
flake.nix                 inputs (nixpkgs, home-manager, zen-browser) + outputs
flake.lock                pinned versions (commit this)
hardware-configuration.nix  machine-specific (you provide — see below)
modules/
  default.nix             imports the modules below
  system.nix              boot, nix, gc, autoUpgrade, users, locale, git
  desktop.nix             GNOME, display, audio, printing, dconf
  packages.nix            system packages, allowUnfree, nix-ld
  home.nix                home-manager + dotfile links + direnv
dotfiles/                 nvim, bash, tmux, ghostty, gdb
templates/rust/           per-project Rust devshell (fenix)
rebuild.sh                pull → rebuild → commit → push
```

## First-time migration (channels → flakes)

Flakes evaluate in *pure* mode and can't read `/etc/nixos`, so your hardware
config must live in the repo:

```sh
cp /etc/nixos/hardware-configuration.nix ~/nixos/
cd ~/nixos
git add -A          # important: flakes only see git-tracked files
sudo nixos-rebuild switch --flake ~/nixos#nixos
```

