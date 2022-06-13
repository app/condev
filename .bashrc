export TERM=xterm-256color
alias ll='ls -l'
alias la='ls -la'
alias vim='nvim'
. ~/.bash_prompt
. ~/.bash_git
. ~/.bash_locale
export PATH=$(yarn global bin):$PATH
[ ! -z "$TMUX" ] && echo "Attention! Ctrl-a is tmux binding. Not Ctrl-b :)"
