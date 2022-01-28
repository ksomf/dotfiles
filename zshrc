autoload -Uz compinit
compinit

path=(
	~/.local/bin
	~/.local/scripts
	~/.local/miniconda/bin
	~/.pyenv/bin
	$path
)

if [[ -d ~/.pyenv/bin ]]; then
	export PYENV_ROOT=~/.pyenv
	eval "$(pyenv init --path)"
	eval "$(pyenv virtualenv-init -)"
fi

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

alias ll='ls -ahFGl'
alias df='df -h'
alias du='du -h'

[ -f ~/.fzf.zsh ]   && source ~/.fzf.zsh
[ -f ~/.ghcup/env ] && source ~/.ghcup/env

#red, blue, green, cyan, yellow, magenta, black, & white
PROMPT='%B%{%F{blue}%}$(virtualenv_prompt_info)%f@%{%F{blue}%}%m%{%F{cyan}%}:%4~%f' #%{%F{cyan}%}%n%f <- username
if [ -f ~/.local/share/zsh-git-prompt/zshrc.sh ] 
then
	GIT_PROMPT_EXECUTABLE="haskell"
	source ~/.local/share/zsh-git-prompt/zshrc.sh
	PROMPT+='$(git_super_status)'
fi
PROMPT+=' %f%(?.%{%F{cyan}%}.%{%F{red}%})%(!.#.>)%f%b '

zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

[ -f ~/.zshrc_extended ] && source ~/.zshrc_extended
[ -f ~/.zshrc_local ]    && source ~/.zshrc_local
