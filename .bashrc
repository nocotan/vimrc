# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Complete after sudo
complete -cf sudo

# append to the history file, don't overwrite it
# shopt -s histappend

# Line wrap on window resize
# shopt -s checkwinsize

# enable autocd feature
# shopt -s autocd

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# enable zsh like auto nd 'set show-all-if-ambiguous on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vi='/usr/bin/vim'
alias sort='LC_ALL=C sort'
alias uniq='LC_ALL=C uniq'
alias sed='LC_ALL=C sed'
alias g++='g++ -std=c++11'
if type "xsel" > /dev/null 2>&1
then
    alias cbp='xsel --clipboard --input'
fi
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# git
alias gitlogf='git log --pretty=format:"%h - %an, %ar : %s" --graph'
alias gita='git add . -A'
alias gitp='git push origin master'

function gitc() {
  command git commit -m $1
}


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.maven_bash_completion.bash ]
then
  . ~/.maven_bash_completion.bash
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Single_line_Solarized
if [[ $- == *i* ]]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi
export ANDROID_HOME="$HOME/tools/android-sdk-linux"
export RUST_SRC_PATH="$HOME/forks/rust/src"
export PATH="$HOME/.local/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
export PATH="$HOME/.npm-packages/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_COMPLETION_TRIGGER='~~'

if [[ -s ~/.nvm/nvm.sh ]];
  then source ~/.nvm/nvm.sh
fi

peco-history() {
  local NUM=$(history | wc -l)
  local FIRST=$((-1*(NUM-1)))

  if [ $FIRST -eq 0 ] ; then
	# Remove the last entry, "peco-history"
	history -d $((HISTCMD-1))
	echo "No history" >&2
	return
  fi

  local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | peco | head -n 1)

  if [ -n "$CMD" ] ; then
	# Replace the last entry, "peco-history", with $CMD
	history -s $CMD

	if type osascript > /dev/null 2>&1 ; then
	  # Send UP keystroke to console
	  (osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
	fi

	# Uncomment below to execute it here directly
	# echo $CMD >&2
	# eval $CMD
  else
	# Remove the last entry, "peco-history"
	history -d $((HISTCMD-1))
  fi
}

bind '"\C-r":"peco-history\n"'

XDG_CONFIG_HOME=~/.config
