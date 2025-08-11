#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Catppuccin Mocha Colors
lavender='\[\e[38;5;141m\]'
pink='\[\e[38;5;211m\]'
blue='\[\e[38;5;117m\]'
mauve='\[\e[38;5;176m\]'
rosewater='\[\e[38;5;224m\]'
reset='\[\e[0m\]'
# Git branch function
parse_git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo " (${branch})"
  fi
}

# Prompt
PS1="${lavender}\u@\h ${mauve}\w${pink}\$(parse_git_branch)${rosewater}\$ ${reset}"

fuzzyFind() {
    local dir
    dir="$(search)"
    if [ -n "$dir" ]; then
        cd "$dir"
    fi

    printf '\e[F\e[K'
}

alias search='ls | fzf'

bind '"\C-s": "fuzzyFind\n"'

alias ll='ls -alF'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

stty -ixon

# autostart tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux
fi

# add .local/bin to PATH
export PATH=$PATH:$HOME/.local/bin

# qt quick vars
export QT_DIR=/usr/lib/qt5
export PATH=$QTDIR/bin:$PATH
export QML_IMPORT_PATH=$QTDIR/qml
export QML2_IMPORT_PATH=$QTDIR/qml
export QT_QPA_PLATFORM_PLUGIN_PATH=$QTDIR/plugins

# Netcore
export PATH=$PATH:$HOME/.dotnet/tools
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT
