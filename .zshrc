# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"
ENABLE_CORRECTION="true"
plugins=(git git-auto-fetch vi-mode poetry)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'

bindkey -v
export KEYTIMEOUT=1

export TERM=xterm-256color

# Custom Commands
gclone() {
    if [ -z $2 ] ; then
        git clone $1 $HOME/Git/$(basename "$1" ".${1##*.}")
    else
        git clone $1 $HOME/Git/"$2"
    fi
}


mkcdir() {
    mkdir "$1" && cd "$1"
}

copyfile() {
    cat "$1" | grep "$2" | xclip -selection clipboard
}

ex () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *.rar)       unrar x $1   ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

pastedit() {
    xclip -o > "$1" && vim -- $1
}

repos() {
    #tree -I env -I __pycache__ -I .git -I target -C --dirsfirst
    cd "$(find $HOME/Git -maxdepth 1 | fzf --layout=reverse-list)" && clear && onefetch
}

ytd() {
    cd $HOME/Videos/ && xclip -o > /tmp/ytdlink.txt && yt-dlp -f mp4 -a /tmp/ytdlink.txt
}

ignore() {
    curl https://www.toptal.com/developers/gitignore/api/$1 > .gitignore
}

gitpush() {
    if [ -z $1 ] ; then
        echo "No repo name specified"
    else
        git push -u git@gitlab.com:Awerito/$1.git --all
    fi
}

# Aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias clean='sudo apt autoremove -y'
alias sudi='sudo apt install'
alias putin='xclip -o >'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias gs='git status'
alias gd='git difftool --tool=nvimdiff -y'
alias gc='git checkout'
alias gl='git log --oneline --decorate --all --graph'
alias e='nvim'
alias clayton='bpython'
alias py='python3'
alias xtree='tree -I env -I __pycache__ -I .git -I target -C --dirsfirst'
alias yt='yt-dlp --merge-output-format mp4/mkv'

alias l='ls --color -lh --group-directories-first'
alias ll='ls -alFh --group-directories-first'
alias la='ls -Ah --group-directories-first'
alias vimdiff='nvim -d'
alias venv="virtualenv env"
alias so="source env/bin/activate && clear"

export PATH=$PATH::$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin/
DOCKER_FORMAT="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"
alias dps='docker ps --format=$DOCKER_FORMAT'

figlet Awerito

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
