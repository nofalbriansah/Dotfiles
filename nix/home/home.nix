{ config, pkgs, unstable, ... }:

{
  imports = [
    # 1. CLI configuration, always included by default.
    ./cli.nix

    # 2. GUI/Gnome modules are NOT included by default.
    # ./gui.nix
    # ./gnome.nix
  ];

  # Basic user and state configuration
  home.username = "nbs";
  home.homeDirectory = "/home/nbs";
  home.stateVersion = "25.11";
  fonts.fontconfig.enable = true;

  ######################
  # Environment Variables
  ######################
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Developments/android/Sdk";
    JAVA_HOME = "${pkgs.jdk21_headless}";
    CHROME_EXECUTABLE = "/usr/bin/firefox";
    PATH = "$PATH" 
    + ":$ANDROID_HOME/emulator"
    + ":$ANDROID_HOME/platform-tools"
    + ":$ANDROID_HOME/cmdline-tools/latest/bin"
    + ":$ANDROID_HOME/tools/bin";
  };
}
