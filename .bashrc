#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

source /usr/share/bash-completion/completions/git

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Catppuccin Mocha Colors
lavender='\[\e[38;5;141m\]'
pink='\[\e[38;5;211m\]'
blue='\[\e[38;5;117m\]'
mauve='\[\e[38;5;176m\]'
rosewater='\[\e[38;5;224m\]'
reset='\[\e[0m\]'

# Monochrome Colors
white='\[\e[1m\]'            # White
white_1='\[\e[38;5;250m\]' # Light gray
light_gray='\[\e[38;5;250m\]' # Light gray
gray='\[\e[38;5;245m\]'       # Medium gray

# Git branch function
parse_git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo " (${branch})"
  fi
}

# Prompt
#PS1="${white}\u@\h ${gray}\w${light_gray}\$(parse_git_branch)${white}\$ ${reset}"
PS1="${white} ${gray}\w${light_gray}\$(parse_git_branch)${white}\n\$ ${reset}"

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
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Netcore
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

export UNITY_PATH="/home/ollie/Unity/Hub/Editor/6000.1.15f1"  # Adjust to your Unity installation
export MSBuildSDKsPath="$HOME/.dotnet/sdk/$(dotnet --version)/Sdks"

. "$HOME/.cargo/env"

export DISPLAY=:0.0

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/opt/Odin:$PATH"
export PATH="/opt/ols/:$PATH"
export PATH="/opt/lua-ls/bin:$PATH"

export QML2_IMPORT_PATH="/usr/share/doc/quickshell"

