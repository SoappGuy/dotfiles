### Plugin Management
# Zinit is a Zsh-only plugin manager.
# In Fish you might consider using fisher (https://github.com/jorgebucaran/fisher)
# For example, to install fish-autosuggestions and fish-nvm:
#
# fisher install jorgebucaran/fish-autosuggestions
# fisher install jorgebucaran/fish-nvm
#
# (Replace the Zinit plugins below with your Fish equivalents.)


### Environment Exports
set -x PATH $PATH $HOME/.local/bin
set -x PATH $PATH $HOME/.cargo/bin
set -x PATH $PATH $HOME/go/bin

set -x WINEPATH $WINEPATH /usr/x86_64-w64-mingw32/bin

set -x RUSTC_WRAPPER /usr/bin/sccache
set -x DOTNET_ROOT "$HOME/.dotnet"

set -x UNI "$HOME/Documents/NURE"

set -x EDITOR nvim
set -x DIFFPROG "nvim -d"
# set -x PAGER bat
# set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"


### (Zsh-specific styling for completions has no direct Fish equivalent.)
# You may need to use Fish's own configuration or themes to style completions.


### Key Bindings
# Fish uses its own binding system. You can rebind keys like so:
# (Adjust or add bindings as desired.)
# For example, to bind Alt+P to search history backward:
# bind \ep 'history-search-backward'
# bind \en 'history-search-forward'
# Note: Some of your Zsh key bindings (like .describe-key-briefly) have no direct Fish equivalent.


### History Settings
# Fish manages history automatically; some Zsh history options aren’t applicable.
# You can configure history file location and size via Fish variables if needed.
# See: https://fishshell.com/docs/current/index.html#history


### Functions

function yy
    set tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file=$tmp
    set cwd (cat $tmp)
    if test -n "$cwd" -a "$cwd" != (pwd)
        cd $cwd
    end
    rm -f $tmp
end

# A “drop” function to run a command in the background and log output.
function drop
    set log_file (printf "%s/%s_%s.log" $XDG_RUNTIME_DIR (basename $argv[1]) (date +%Y%m%d%H%M%S))
    $argv > $log_file 2>&1 &
end


function ls
    eza --icons $argv
end

function tree
    eza --icons --tree $argv
end

# function cat
#     # Uncomment if you want to use 'bat' instead of 'cat'
#     bat $argv
# end

function cd
    # Assuming you have a "z" command available in Fish (or an equivalent)
    z $argv
end

function cp
    advcp -g $argv
end

function mv
    advmv -g $argv
end

function rm
    trash $argv
end

function sync
    ~/.scripts/watch_sync.sh $argv
end

function paru
    command paru --bottomup $argv
end

function s
    kitten ssh $argv
end

function say
    cowsay $argv
end

function init_c_winapi
    echo "Writing .clangd file for Windows API development..."

    echo "\
CompileFlags:
  Add:
    - -I/usr/x86_64-w64-mingw32/include
    - -I/usr/x86_64-w64-mingw32/include/w32api
    - -DUNICODE
    - -D_UNICODE
    - --target=x86_64-w64-mingw32" > .clangd

    echo "Creating main.c..."

    echo "\
#include <windows.h>

int main() {
    printf(\"Hello, World!\\n\");
    return 0;
}
" > main.c

    echo "Writing Makefile..."

    echo "\
main: main.c
	x86_64-w64-mingw32-gcc -Wall -Wextra -o main.exe main.c

clean:
	rm -f main.exe "

    echo "Done!"
end

### Shell Integrations

# Starship prompt initialization for Fish
# starship init fish | source

# zoxide initialization for Fish
zoxide init fish | source

# fzf integration for Fish
fzf --fish | source


### fzf Settings
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_DEFAULT_OPTS "--height 50% --layout=default --border --color=hl:#2dd4bf"
set -x FZF_CTRL_T_OPTS "--preview 'eza --icons=always --tree --color=always {} | head -200'"
set -x FZF_ALT_C_OPTS "--preview 'eza --icons=always --tree --color=always {} | head -200'"


### gpg Agent Setup
set -x GPG_TTY (tty)
gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
