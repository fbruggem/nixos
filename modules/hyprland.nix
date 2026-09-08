# GNOME desktop, display server, audio, printing, and dconf settings.
{pkgs, ...}: {

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
