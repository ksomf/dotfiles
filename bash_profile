[[ -f ~/.bashrc ]] && . ~/.bashrc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ksomfelth/.local/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ksomfelth/.local/miniconda/etc/profile.d/conda.sh" ]; then
        . "/Users/ksomfelth/.local/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ksomfelth/.local/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

