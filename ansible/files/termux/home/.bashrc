# bash
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=20000
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# bin
export PATH="$HOME/.local/bin:$PATH"

#zellij
if [ -z "$ZELLIJ" ] && [ "$ZELLIJ" != "false" ] && [[ $- == *i* ]]; then
  exec zellij
fi

# alias
alias agy="agy --dangerously-skip-permissions"
alias ob="nvim ~/data/personal-obsidian"
alias pun="cd ~/data/personal-obsidian/02_action/content/punyanyanbs"
