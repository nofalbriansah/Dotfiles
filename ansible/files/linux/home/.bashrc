#
# ~/.bashrc
#

[[ $- != *i* ]] && return

# Source universal path settings
if [ -f "$HOME/.linux_path" ]; then
    . "$HOME/.linux_path"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# Added by Antigravity CLI installer
export PATH="/home/nbs/.local/bin:$PATH"
