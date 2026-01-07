# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"


# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions 
zinit light Aloxaf/fzf-tab

autoload -Uz compinit && compinit


zinit cdreplay -q


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTDUP=erase


# +-------------------+
# |   INTEGRATIONS    |
# +-------------------+
eval "$(zoxide init zsh)"
source <(fzf --zsh)


# +-------------------+
# |       BINDS       |
# +-------------------+
bindkey "^R" fzf-history-widget
bindkey "^n" history-search-forward
bindkey "^p" history-search-backward
bindkey "^f" autosuggest-accept


# +-------------------+
# |     MAIN OPTS     |
# +-------------------+
unsetopt BEEP # Turn off beeping noice
setopt append_history inc_append_history share_history hist_ignore_space # Better History
setopt hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
setopt auto_menu menu_complete
setopt autocd
setopt interactive_comments


# +-------------------+
# |    Completions    |
# +-------------------+
zstyle  ':completion:*' completer _extensions _complete _approximate
zstyle  ':completion:*' matcher-list    'm:{a-z}={A-Za-z}'
zstyle  ':completion:*' list-colors     "${(s.:.)LS_COLORS}"
zstyle  ':completion:*' menu no
zstyle  ':completion:*' use-cache       true
zstyle  ':completion:*' rehash          false
zstyle  ':completion:*' list-dirs-first yes
zstyle  ':completion:*' file-sort modification  # show recently used files first

LISTMAX=10000


# +-------------------+
# |      ALIASES      |
# +-------------------+
alias l="eza --git --group-directories-first -1 --icons" # long list
alias ls="eza --git --group-directories-first --icons" # short list
alias ll="eza -lhF --icons=auto --sort=name --group-directories-first" # long list all
alias la="eza --git --group-directories-first --icons -a"
alias lt='eza --git --group-directories-first --icons -T'
alias ltl='eza --git --group-directories-first --icons -TL'
alias tree="tree -a -l -C -I '.git' --gitignore --dirsfirst"

alias v="nvim"
alias suv="sudo nvim"

alias rm="rm -rf"
alias cp="cp -ir"
alias mv="mv -iv"
alias t="touch"
alias cat="bat"

alias pacsu="sudo pacman -Syu"  # update
alias paci="sudo pacman -S"     # install
alias pacrc="sudo pacman -Sc"   # clear cache
alias pacrr="sudo pacman -Rs"   # remove pkg with unsed deps
alias pacss="sudo pacman -Ss"   # search
alias paccc="sudo pacman -Scc"  # empty whole cache

alias kssh="kitty +kitten ssh" # when ssh from my kitty terminal
alias zf="zathura --fork"
alias ga="gitalias"

# Get week number
alias week='date +%V'

# xh -> http
alias http="xh"

# Print each PATH entry on a separate line
alias echopath='echo -e ${PATH//:/\\n}'

alias cdff='cd $(fd --type d . | fzf --preview "exa --long --icons --color=always {}")'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

alias img="viewnior"

# Tmux
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

alias rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim --colors=line:fg:black --colors=line:style:bold --colors=path:fg:green --colors=match:style:nobold"

# Docker
alias dkps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dkl='docker logs --tail=100'
alias dkc='docker compose'
alias dkcu='docker compose up'
alias dkcd='docker compose down'
alias dkcud='docker compose up -d'
alias dkbuc="docker compose build"
alias dkxec='docker exec -it' # container_name || container_name [commands] || container_name psql -U postgres -d todoapp
alias dkimg="docker images"
alias dkimgr="docker image rm"
alias dkvol="docker volume ls"

# Process management
alias ports="netstat -tuln"
alias psg="ps aux | grep"
alias disk="df -h"
export MANGOHUD=1

# +-------------------+
# |        ENV        |
# +-------------------+
# Binfiles completion setup
export PATH=$PATH:/home/draco/binfiles
source /home/draco/binfiles/.completions/_bin_completions.sh >/dev/null 2>&1
export PATH="$HOME/.local/share/bob/nvim-bin/:$PATH"

export VISUAL="nvim"
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="zen-browser"

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

# GOLANG
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Npm
export PATH="$HOME/.npm/_npm-global/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Starship
export STARSHIP_CACHE=~/.starship/cache
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi


# +-------------------+
# |       EXTRA       |
# +-------------------+
# call neovide
vv(){
    neovide $@ & disown
}

# Extract any archive
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1    ;;
            *.tar.gz)    tar xzf $1    ;;
            *.bz2)       bunzip2 $1    ;;
            *.rar)       unrar x $1    ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xf $1     ;;
            *.tbz2)      tar xjf $1    ;;
            *.tgz)       tar xzf $1    ;;
            *.zip)       unzip $1      ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1       ;;
            *)           echo "'$1'cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Get size of folders / files in current dir
ffsize () {
    du -sh * | sort -h
}

mk() {
  mkdir --parents "$1" && cd "$1"
}

man() {
  GROFF_NO_SGR=1 \
  LESS_TERMCAP_mb=$'\e[31m' \
  LESS_TERMCAP_md=$'\e[34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;30m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[35m' \
  command man "$@"
}

# yt-dlp
dl-yt () {
    if [[ $# -lt 3 ]] || [[ "$1" == "-h" ]]; then
        echo "Usage: dl-yt [ resolution ] [ type v | p ] [url..]"
        echo "Types:"
        echo "\tv = video"
        echo "\tp = playlist"
        return 1
    fi

    local resolution=$1
    local vtype=$2
    local format="bestvideo[height<=${resolution}][ext=mp4]+bestaudio[ext=m4a]"

    if [[ $vtype == "p" ]]; then
        yt-dlp -f "$format" -o "%(playlist)s/%(title)s.%(ext)s" "$3"
    else
        yt-dlp -f "$format" -o "%(title)s.%(ext)s" "$3"
    fi
}
_dl-yt(){
    local state
    local -a line

    _arguments \
        '1:resolution:(360 480 720 1080)' \
        '2:type:(v p)' \
        '3:url:_urls'
}
compdef _dl-yt dl-yt

pyserve () {
    python3 -m http.server ${1:-2020}
}


# bun completions
[ -s "/home/draco/.bun/_bun" ] && source "/home/draco/.bun/_bun"

# Starship
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/draco/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
