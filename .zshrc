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

zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# load zsh-complitions
autoload -U compinit && compinit
zinit cdreplay -q

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

# aliases
alias ls="exa --icons"
alias cat="bat"
alias cp="advcp -g"
alias mv="advmv -g"

# Start starship prompt
eval "$(starship init zsh)"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Exports
export PATH="$PATH:/home/dumbnerd/.local/bin"
export RUSTC_WRAPPER=/home/dumbnerd/.cargo/bin/sccache
export EDITOR=nvim
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/jre

# gpg agent
export GPG_TTY=$(tty)
gpg-connect-agent --quiet updatestartuptty /bye >/dev/null
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
