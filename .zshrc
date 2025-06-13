# Auto start Hyprland on tty1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  mkdir -p ~/.cache
  exec Hyprland > ~/.cache/hyprland.log 2>&1
fi

# Setup zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source installed zinit
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait lucid
zinit light sudosubin/zsh-poetry

zinit ice wait lucid
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

autoload -Uz compinit
compinit -C

zinit cdreplay -q

# Exports
# source ./credentials.zsh
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
# export RUSTC_WRAPPER="$HOME/.cargo/bin/sccache"
export RUSTC_WRAPPER="/usr/bin/sccache"
export EDITOR=nvim
export DOTNET_ROOT="$HOME/.dotnet"
export UNI="$HOME/Documents/NURE"
export DIFFPROG="nvim -d"

# Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 $realpath'

# Keybinds
autoload -U history-search-end
bindkey -e
bindkey '^[v' .describe-key-briefly
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward
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
alias ls="eza --icons"
alias tree="eza --icons --tree"
# alias cat="bat"
alias cd="z"
alias cp="advcp -g"
alias mv="advmv -g"
alias rm="trash"
alias sync="~/.scripts/watch_sync.sh"
alias paru="paru --bottomup"
alias s="kitten ssh"
alias vi="nvim"
alias vim="nvim"
alias e="nvim"
alias dumpbin="wine /opt/dumpbin"

# functions
drop() {
  log_file="$XDG_RUNTIME_DIR/$(basename "$1")_$(date +%Y%m%d%H%M%S).log"
  "$@" > "$log_file" 2>&1 & disown
}

# Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# fzf settings
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
# export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_CTRL_T_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# gpg agent
# export GPG_TTY=$(tty)
# gpg-connect-agent --quiet updatestartuptty /bye >/dev/null
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export SSH_AUTH_SOCK=~/.bitwarden-ssh-agent.sock
