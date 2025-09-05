{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    gnome-tweaks

    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.dash2dock-lite
    gnomeExtensions.blur-my-shell
    gnomeExtensions.arcmenu
    gnomeExtensions.just-perfection
    gnomeExtensions.top-bar-organizer
  ];
}

