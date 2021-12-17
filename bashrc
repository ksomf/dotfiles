[[ $- != *i* ]] && return

[[ -f /etc/bashrc ]] && source /etc/bashrc

# Bind arrows to partial search through history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'
shopt -s histappend 2> /dev/null #Don't delete history
export HISTCONTROL="ignorespace:erasedups" #Don't add duplicate entries
export HISTSIZE=10000
export HISTFILESIZE=10000

export EDITOR="vim"

reset=$(tput sgr0)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
brightblack=$(tput setaf 8)
brightred=$(tput setaf 9)
brightgreen=$(tput setaf 10)
brightyellow=$(tput setaf 11)
brightblue=$(tput setaf 12)
brightmagenta=$(tput setaf 13)
brightcyan=$(tput setaf 14)
brightwhite=$(tput setaf 15)

if ls --color > /dev/null 2>&1; then 
	colorflag="--color" #GNU ls
else 
	colorflag="-G" #OSX ls
fi
alias ls='ls -lhF ${colorflag}'
alias ll='ls -a'
alias df='df -h'
alias du='du -h'
[[ $TERM == xterm-kitty ]] && alias ssh='kitty +kitten ssh'

PATH=~/.local/bin:$PATH
PATH=~/.local/scripts:$PATH
PATH=~/.local/miniconda/bin:$PATH

if [[ -d /opt/intel/bin ]]; then
	. /opt/intel/bin/compilervars.sh intel64
	. /opt/intel/bin/debuggervars.sh
fi

[[ -f ~/.ghcup/env ]] && source ~/.ghcup/env # ghcup-env
[[ -f ~/.local/scripts/git-completion.bash ]] && source git-completion.bash
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

if [[ "$USER" == "root" ]]; then
	prompt_col_1=$brightred
	prompt_col_2=$red
elif [[ "$SSH_TTY" ]]; then
	prompt_col_1=$brightgreen
	prompt_col_2=$green
else
	prompt_col_1=$brightblue
	prompt_col_2=$blue
fi

PS1='\[$reset\]\[$prompt_col_1\]\u\[$reset\]@\[$prompt_col_2\]\h\[$prompt_col_1\]:\W'
#if [ -f ~/.local/scripts/git-prompt.sh ]; then
#	source ~/.local/scripts/git-prompt.sh
#	export GIT_PS1_SHOWDIRTYSTATE=true
#	export GIT_PS1_SHOWUNTRACKEDFILES=true
#	export GIT_PS1_SHOWUPSTREAM='auto'
#	export PS1+='\[$prompt_col_2\]$(__git_ps1 "(%s)")'
#fi
PS1+='\[$reset\]\$ '

[[ -f ~/.bashrc_local ]] && source ~/.bashrc_local ]
