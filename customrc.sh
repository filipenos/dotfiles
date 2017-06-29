if [ -f ~/.customrc ]; then
  source ~/.customrc
fi

if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# Aliases
alias clean-number="sed 's/[^0-9]*//g'"
alias serve-dir="python -m SimpleHTTPServer"
alias change-ps1='export PS1="\e[0;34m\W: \e[m"'
alias npm-list="npm list -g --depth=0"
alias dpkg-purge-rc='dpkg -l | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge'

alias starwars="telnet towel.blinkenlights.nl"

# Necessary to use tmux plugin manager
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"