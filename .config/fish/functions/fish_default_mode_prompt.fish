function fish_default_mode_prompt --description 'Display vi prompt mode'
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" != fish_vi_key_bindings
        and test "$fish_key_bindings" != fish_hybrid_key_bindings
        return
    end

    if test "$fish_bind_mode" = insert
        return
    end

    switch $fish_bind_mode
        case default
            set_color --bold brmagenta
            echo N
        case visual
            set_color --bold brcyan
            echo V
        case replace_one
            set_color --bold bryellow
            echo R
        case replace
            set_color --bold brred
            echo R
    end

    set_color normal
    echo -n ' '
end
