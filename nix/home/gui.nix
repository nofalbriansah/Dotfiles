{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    ######################
    # Themes
    ######################
    colloid-icon-theme
    marble-shell-theme

    ######################
    # GUI Apps (stable)
    ######################
    abdownloadmanager # (Custom package)
    discord
    calibre
    gimp3-with-plugins
    ghostty
    gnome-disk-utility
    gnome-pomodoro
    gnome-system-monitor
    heroic-unwrapped
    kdePackages.kdenlive
    obs-studio
    onlyoffice-desktopeditors
    vlc
    zoom-us
    zotero

    ######################
    # GUI Apps (unstable)
    ######################
    unstable.firefox
    unstable.flclash
    unstable.google-chrome
    unstable.obsidian

    #######################
    # Dev / SDK / IDE Tools (GUI)
    #######################
    unstable.code-cursor-fhs
    unstable.flutter
    unstable.godot
    unstable.vscode
  ];
}
