# ============================================
# OH-MY-ZSH CONFIGURATION
# ============================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="false"
ENABLE_CORRECTION="false"

# Auto-install plugins
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
fi

plugins=(git git-auto-fetch vi-mode poetry zsh-autosuggestions zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
bindkey '^V' autosuggest-disable

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  PROMPT='🔴 '$PROMPT
fi

# ============================================
# EDITOR & TERMINAL
# ============================================
export EDITOR='nvim'
export TERM=xterm-256color
bindkey -v
export KEYTIMEOUT=1

# ============================================
# CUSTOM FUNCTIONS
# ============================================
ex() {
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
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

repos() {
    cd "$(find $HOME/Git -maxdepth 1 | fzf --layout=reverse-list)" && clear && onefetch
}

ytd() {
    cd $HOME/Videos/ && xclip -o > /tmp/ytdlink.txt && yt-dlp -f mp4 -a /tmp/ytdlink.txt
}

gi() {
    curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$(IFS=,; echo "$*")"
}

pip() {
    if [[ -z "$VIRTUAL_ENV" ]]; then
        echo "⚠️  No hay venv activado. ¿Estás seguro? [y/N]"
        read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        command pip "$@"
    else
        echo "Cancelado."
    fi
    else
        command pip "$@"
    fi
}

# ============================================
# ALIASES - SYSTEM
# ============================================
alias update='sudo apt update && sudo apt upgrade -y'
alias clean='sudo apt autoremove -y'
alias sudi='sudo apt install'
alias l='ls --color -lh --group-directories-first'
alias ll='ls -alFh --group-directories-first'
alias la='ls -Ah --group-directories-first'

# ============================================
# ALIASES - GIT
# ============================================
alias gs='git status'
alias gd='git difftool --tool=nvimdiff -y'
alias gc='git checkout'
alias gl='git log --decorate --all --graph --pretty=format:"%C(auto)%h%d %s %C(blue)%cr %C(green)%an"'
alias glb='git log --decorate --all --graph --pretty=format:"%C(auto)%h%d %s %C(blue)%cr %C(green)%an%n%b"'

# ============================================
# ALIASES - DEVELOPMENT
# ============================================
alias e='nvim'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias vimdiff='nvim -d'
alias clayton='bpython'
alias py='python3.12'
alias venv="virtualenv env"
alias so="source env/bin/activate && clear"
alias v="find . \( -path ./node_modules -o -path ./.git -o -path ./env -o -name '*.pyc' \) -prune -o -type f -print | fzf --reverse | xargs -o nvim"

# ============================================
# ALIASES - UTILITIES
# ============================================
alias putin='xclip -o >'
alias xtree='find . -type d -name "__pycache__" -exec rm -r {} + && tree --gitignore --dirsfirst'
alias yt='yt-dlp --merge-output-format mp4/mkv'
alias md2pdf='f=$(ls *.md); pandoc -t beamer --pdf-engine=xelatex "$f" -o "${f%.md}.pdf"'

DOCKER_FORMAT="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"
alias dps='docker ps --format=$DOCKER_FORMAT'

# ============================================
# PATH & EXTERNAL TOOLS
# ============================================
export PATH=$PATH:$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin:$HOME/.local/scripts

# NVM (compatible con instalación manual y pacman)
export NVM_DIR="$HOME/.nvm"
[ ! -d "$NVM_DIR" ] && mkdir -p "$NVM_DIR"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  \. "$NVM_DIR/nvm.sh"
elif [ -s "/usr/share/nvm/nvm.sh" ]; then
  \. "/usr/share/nvm/nvm.sh"
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "/usr/share/nvm/bash_completion" ] && \. "/usr/share/nvm/bash_completion"

# LaTeX
export PATH="$PATH:/usr/local/texlive/2024/bin/x86_64-linux"
export MANPATH="$MANPATH:/usr/local/texlive/2024/texmf-dist/doc"
export INFOPATH="$INFOPATH:/usr/local/texlive/2024/texmf-dist/doc/info"

# Go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# ============================================
# ZSH COMPLETION
# ============================================
fpath+=~/.zfunc
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# opencode
export PATH=/home/awe/.opencode/bin:$PATH
