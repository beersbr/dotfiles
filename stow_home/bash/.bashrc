# .bashrc

# if not running in interactive mode then stop github:bahamas10
[[ -n $PS1 ]] || return

# Source global definitions -- this is from Fedora installs
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
export SYSTEMD_PAGER='less'
export PAGER='less'
export EDITOR='nvim'
export VISUAL='nvim'


# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# User specific environment and startup programs
alias gs="git status -uno"
alias gss="git status --ignored=traditional"
alias gc="git commit -m"
alias ga="git add"

alias ll="ls -al --color=auto"
alias ls="ls --color=auto"

force_color_prompt=yes

source .git-prompt.sh
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'; PS1='\t \u\[\e[38;5;32m\]@\[\e[0m\]\h\[\e[38;5;242m\][\[\e[0m\]\w \[\e[38;5;242m\]]\[\e[38;5;247m\]${PS1_CMD1}\[\e[0m\]\$ '

#### PYENV $ curl -fsSL https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
