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
  home.stateVersion = "25.05";

  ######################
  # Environment Variables
  ######################
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Developments/android-sdk";
    ANDROID_SDK_ROOT = "$HOME/Developments/android-sdk";
    JAVA_HOME          = "${pkgs.jdk21_headless}";
    #CHROME_EXECUTABLE  = "${unstable.google-chrome}/bin/google-chrome-stable";
    #TERMINAL           = "ghostty";
  };
}
