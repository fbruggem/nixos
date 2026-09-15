# Declarative Flatpaks via nix-flatpak (github:gmodena/nix-flatpak).
#
# NixOS itself only has `services.flatpak.enable`. nix-flatpak adds the rest
# (app list, remotes, overrides, update timer) and applies it with a systemd
# oneshot, `flatpak-managed-install`, that runs on every boot and every
# `nixos-rebuild switch`. It diffs this config against the state it saved last
# time (/nix/var/nix/gcroots/flatpak-state.json) and installs/removes the
# difference.
#
# Unlike the rest of this flake, app *versions* are not pinned by flake.lock:
# Flatpaks live in /var/lib/flatpak, outside the Nix store, and come straight
# from Flathub at install/update time. The list is declarative; the versions
# float (unless you pin a commit, see below).
{inputs, ...}: {
  # `inputs` arrives via specialArgs (flake.nix), which is why it can be used
  # inside `imports`; arguments set through _module.args can't.
  imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];

  services.flatpak = {
    enable = true;

    # Flathub is nix-flatpak's default remote; spelled out so it's visible.
    # Setting this list replaces the default, so keep flathub in it.
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    # App ID = last part of the Flathub URL (flathub.org/apps/com.spotify.Client)
    # or the "Application ID" column of `flatpak search <name>`.
    packages = [
      # "com.spotify.Client"

      # Long form. Pinning a commit freezes the app (the update timer skips it);
      # list commits with `flatpak remote-info --log flathub <app-id>`.
      # { appId = "com.spotify.Client"; origin = "flathub"; commit = "<hash>"; }
    ];

    # Strict mode: this file is the whole truth. On the next switch/boot,
    # nix-flatpak uninstalls every Flatpak not listed above (including ones
    # installed via GNOME Software), deletes undeclared remotes, and removes
    # unused runtimes (uninstallUnused defaults to this value).
    # App data in ~/.var/app/<app-id> is kept.
    uninstallUnmanaged = true;

    update = {
      # Don't update on every switch: keeps rebuilds fast and repeatable.
      onActivation = false;
      # Update all (unpinned) apps from a systemd timer instead. The timer is
      # persistent, so a run missed while the laptop was off happens at boot.
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };

    # Declarative Flatseal: same as `flatpak override --system ...`.
    # (This is the nix-flatpak 0.7 syntax; newer releases also accept it, and
    # prefer the same attrset under `overrides.settings`.)
    # overrides = {
    #   # Let Spotify's "Local Files" read ~/Music:
    #   "com.spotify.Client".Context.filesystems = ["xdg-music:ro"];
    # };
  };
}
