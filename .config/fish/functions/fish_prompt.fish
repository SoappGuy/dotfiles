function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -q fish_color_status; or set -g fish_color_status brred
    set -l normal (set_color normal)

    # Only show login if in SSH or container
    if not set -q prompt_host
        set -g prompt_host "" # global because it's slow and unchanging
        if set -q SSH_TTY
            or begin
                command -sq systemd-detect-virt
                and systemd-detect-virt -q
            end
            set prompt_host "$(prompt_login) "
        end
    end

    # Write pipestatus if a command was issued
    if test "$__fish_prompt_status_generation" != $status_generation
        set -f prompt_status (__fish_print_pipestatus '' '' '|' '' (set_color --bold $fish_color_status) $last_pipestatus)
        set -g __fish_prompt_status_generation $status_generation
    end

    # Color the prompt differently when we're root
    set -l suffix '>'
    set -l color_cwd $fish_color_cwd
    if fish_is_root_user
        set suffix '#'
        set -q fish_color_cwd_root; and set color_cwd $fish_color_cwd_root
    end

    echo -n -s $prompt_host (set_color $color_cwd) (prompt_pwd -D2) $normal ' ' $prompt_status $suffix ' '
end
