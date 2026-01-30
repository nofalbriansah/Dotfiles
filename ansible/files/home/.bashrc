#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- CUSTOM PROMPT ---
PS1='[\u@\h \W]\$ '

# --- MODULAR LOADER ---
# This sources any extra files you drop into ~/.config/bash/
if [ -d "$HOME/.config/bash" ]; then
    for file in "$HOME/.config/bash/"*; do
        # Avoid sourcing itself or directories
        [ -f "$file" ] && [ "${file##*/}" != ".bashrc" ] && . "$file"
    done
fi

# --- ENVIRONMENT VARIABLES (PATH) ---
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"