# User friendly, colorized and linux like bash

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'




# Original PATH

PATH=/usr/bin:/bin:/usr/sbin:/sbin



# Homebrew modification PATH

PATH=/usr/local/bin:/usr/local/sbin:"$PATH"
export PATH



# iTerm2 shell integration

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
