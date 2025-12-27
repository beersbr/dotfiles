# .bashrc

# if not running in interactive mode then stop. Source github:bahamas10
[[ -n $PS1 ]] || return


red=$'\\e[1;31m'
nocolor=$'\\e[0m'


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
alias gd="git diff --minimal --word-diff=color"
alias gdd="git diff"
alias gl="git log --graph --decorate"
alias gll="git log --graph --oneline --all --decorate"
alias git_current_branch="git rev-parse --abbrev-ref HEAD"

alias ll="ls -al --color=auto"
alias ls="ls --color=auto"

force_color_prompt=yes

if [ ! "$(type -t __git_ps1)" = "function" ]; then
    case $(awk -F= '$1=="ID" {print $2}' /etc/os-release) in
        fedora) source /usr/share/git-core/contrib/completion/git-prompt.sh;;
        ubuntu) source /usr/lib/git-core/git-sh-prompt;;
        *) echo -e "${red}OOPS: No git-prompt found${nocolor}"
        # arch) source /usr/share/git/completion/git-prompt.sh
    esac

fi

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto"

PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'; PS1='\t \u\[\e[38;5;32m\]@\[\e[0m\]\h\[\e[38;5;242m\][\[\e[0m\]\w \[\e[38;5;242m\]]\[\e[38;5;247m\]${PS1_CMD1}\[\e[0m\]\$ '

# *******************************************************************
# UTIL FUNCTIONS
# *******************************************************************

function use {
    # This is for python virtual environments. It looks for the python bin set up -- instead
    # of typing . .vevn/bin/activate this finds the virtual environment by name. This can
    # be replaced by pyenv fully. I just like having the venvs in the project dirs
    #
    # Usage:
    # $ use # uses the $DEFAULT_NAME
    # $ use venv311 # looks for virtual environment folder named venv311
    local DEFAULT_NAME=".venv"
    if [ ! -z "$VIRTUAL_ENV" ]; then
            echo "deactivating current venv... $VIRTUAL_ENV"
            deactivate
    fi

    local venv=$1
    if [ -z "$venv" ]; then
            venv=$DEFAULT_NAME
    fi


    local local_path="./"
    spushd $local_path
    venv="$local_path$venv"

    echo "looking for virtualenv named: $venv"
    while [ ! -d $venv ]; do
            spopd
            local_path="$local_path../"
            spushd $local_path

            echo "looking in $(pwd)"

            if [ $(pwd) = "/" ]; then
                    echo "could not find virtualenv $venv"
                    break
            fi
    done

    echo "Using: $venv/bin/activate" 
    . $venv/bin/activate
    spopd
}

alias unuse=deactivate


function gc {
    # This is a special way to git commit. Its shorter and will prepend the branch name in the commit message
    # if it matches the jira (PROJ-1234) style branch names. In essence name your branch the jira ticket and get a
    # branc name prepended commit message.
    echo "--: Workign on $(git_branch). Checking for common ticket patterns..."

    if [ -z "$1" ]; then
            echo "--: Nothing used as comment. Showing status instead of commiting code."
            git status
            return  0
    fi

    TICKET=$(git_branch | cut -f 1,2 -d '-')

    if [[ "$TICKET" =~ ^[A-Z]{2,}\-[0-9]{1,}(\-.*)?$ ]]; then
            echo "--: Will prepend branch name to commit: $TICKET."
            echo "--: final message: $TICKET: $1"
            gc "$TICKET: $1"
    else
            gc "$1"
    fi

    return 1
}



function gitparent {
    # try get the parent branch that the current branch came from
    git show-branch -a \
    | grep '\*' \
    | grep -v `git rev-parse --abbrev-ref HEAD` \
    | head -n1 \
    | sed 's/.*\[\(.*\)\].*/\1/' \
    | sed 's/[\^~].*//'
}


function git_eradicate {
    # Get rid of everything ^o^
    git filter-branch -f  --index-filter 'git rm --force --cached --ignore-unmatch $1' -- --all
    rm -Rf .git/refs/original && \
    git reflog expire --expire=now --all && \
    git gc --aggressive && \
    git prune
}


function git_squash() {
    # Squash current branch based on branch from given branch
    git reset $(git merge-base $1 $(git branch --show-current))
}


function whats_big() {
    # Better version of the big file finder from github:nnewsom
    local HEADER_LINES=2
    local DEFAULT_LINES=7
    local COUNT=$(($DEFAULT_LINES+$HEADER_LINES))

    if [ $# -ne 0 ]; then
        COUNT=$(($1+$HEADER_LINES))
    fi
    du -ca --max-depth=4 | sort -nr | head -n "$COUNT" | tail -n+2 | awk -F' ' '{ printf ("%12d %s\n",$1,$2) }'
}


function encrypt_file() {
    # Encrypt file using openssl. source github:nnewsom
    openssl aes-256-cbc -a -pbkdf2 -salt -in "$1" -out "$1".enc
}


function decrypt_file() {
    # Decrypt previousy encrypted file using openssl. Source github:nnewsom
    openssl aes-256-cbc -d -a -pbkdf2 -salt -in "$1" -out "$1".plaintext
}


# *******************************************************************
# COMMON TOOL SETUP
# *******************************************************************
if [ -e "$HOME/.pyenv/bin/pyenv" ]; then
    #### PYENV $ curl -fsSL https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
else
    echo -e "${red}OOPS: pyenv not found; shell setup being ignored.${nocolor}"
    echo "Try: \"curl -fsSL https://pyenv.run | bash\" from https://github.com/pyenv/pyenv?tab=readme-ov-file#a-getting-pyenv"
fi
