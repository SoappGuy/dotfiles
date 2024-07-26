# Setup zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source installed zinit
source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light sudosubin/zsh-poetry

zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# load zsh-complitions
autoload -U compinit && compinit
zinit cdreplay -q

# Exports
# source ./credentials.zsh
export PATH="$PATH:/home/dumbnerd/.local/bin"
export PATH="$PATH:/home/dumbnerd/.cargo/bin"
export RUSTC_WRAPPER=/home/dumbnerd/.cargo/bin/sccache
export EDITOR=nvim
# export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/jre
export DOTNET_ROOT=$HOME/.dotnet

# Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --icons -1 $realpath'

# Keybinds
bindkey -e
bindkey '^[v' .describe-key-briefly
bindkey '^[p' history-search-backward
bindkey '^[n' history-search-forward
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# functions
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# aliases
alias ls="exa --icons"
alias tree="exa --icons --tree"
alias cat="bat"
alias cd="z"
alias cp="advcp -g"
alias mv="advmv -g"
alias rm="trash"
alias sync="~/.scripts/watch_sync.sh"
alias paru="paru --bottomup"

# Start starship prompt
eval "$(starship init zsh)"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# gpg agent
export GPG_TTY=$(tty)
gpg-connect-agent --quiet updatestartuptty /bye >/dev/null
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
