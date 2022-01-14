autoload -Uz compinit
compinit

source <(antibody init)

antibody bundle robbyrussell/oh-my-zsh path:plugins/git
antibody bundle robbyrussell/oh-my-zsh path:plugins/branch

antibody bundle robbyrussell/oh-my-zsh path:plugins/docker
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker-compose
antibody bundle robbyrussell/oh-my-zsh path:plugins/fzf
antibody bundle robbyrussell/oh-my-zsh path:plugins/rsync
#antibody bundle robbyrussell/oh-my-zsh path:plugins/ssh-agent
antibody bundle robbyrussell/oh-my-zsh path:plugins/z

antibody bundle robbyrussell/oh-my-zsh path:plugins/pip
antibody bundle robbyrussell/oh-my-zsh path:plugins/pipenv
antibody bundle robbyrussell/oh-my-zsh path:plugins/pyenv
antibody bundle robbyrussell/oh-my-zsh path:plugins/virtualenv

antibody bundle robbyrussell/oh-my-zsh path:plugins/cabal

antibody bundle robbyrussell/oh-my-zsh path:plugins/bedtools
antibody bundle robbyrussell/oh-my-zsh path:plugins/samtools

#antibody bundle robbyrussell/oh-my-zsh path:plugins/kubectl
#antibody bundle robbyrussell/oh-my-zsh path:plugins/kubectx

antibody bundle robbyrussell/oh-my-zsh path:plugins/jsontools

antibody bundle zsh-users/zsh-syntax-highlighting


#Remember !! is the last command 

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

export GIT_EDITOR=vim
export EDITOR='vim'
COMPLETION_WAITING_DOTS="true"

setopt NO_CASE_GLOB
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
SAVEHIST=10000
HISTSIZE=10000

alias ll='ls -a'
alias df='df -h'
alias du='du -h'

path=(
	~/.local/bin
	~/.local/scripts
	~/.local/miniconda/bin
	~/.pyenv/bin
	$path
)

PROMPT='%F{green}%n%f@%F{blue}%m%F{green}:%4~ %f%# '

zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
