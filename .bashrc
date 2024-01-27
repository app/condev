export TERM=screen-256color
alias ll='ls -l'
alias la='ls -la'
alias vim='nvim'
. ~/.bash_prompt
. ~/.bash_git
. ~/.bash_locale
export PATH=$(YARN_IGNORE_PATH=1 yarn global bin 2>/dev/null):$PATH
[ ! -z "$TMUX" ] && echo "Attention! Ctrl-a is tmux binding. Not Ctrl-b :)"
