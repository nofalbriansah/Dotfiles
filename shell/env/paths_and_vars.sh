#!/bin/bash

# Universal PATH and environment variables config

# PATH
export PATH="$HOME/.nix-profile/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/Developments/Android/Sdk/platform-tools:$PATH"
export PATH="$HOME/Developments/Android/Sdk/ndk-build:$PATH"
export PATH="$HOME/Developments/flutter/bin:$PATH"
export PATH="$HOME/.dotnet:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"

# Env Vars
export JAVA_HOME="/usr/lib/jvm/default"
export DOTNET_ROOT="$HOME/.dotnet"
export MONO_HOME="/usr/lib/mono"
export ANDROID_HOME="$HOME/Developments/Android/Sdk"
export FLUTTER_HOME="$HOME/Developments/flutter/bin"
export NODE_PATH="/usr/lib/node_modules"
