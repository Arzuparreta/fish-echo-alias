# Extends fish's `alias` so `alias NAME` (no `=`) prints the command string via echo_alias.
# Stock implementation is loaded lazily from $__fish_data_dir (see fish-shell alias.fish).

function alias --description 'Creates a function wrapping a command'
    if not functions -q __fish_stock_alias
        set -l stock "$__fish_data_dir/functions/alias.fish"
        if not test -f "$stock"
            printf '%s\n' "fish-echo-alias: stock alias.fish not found at $stock" >&2
            return 1
        end
        string replace 'function alias ' 'function __fish_stock_alias ' <$stock | source
        or return 1
        if not functions -q __fish_stock_alias
            printf '%s\n' 'fish-echo-alias: failed to load stock alias (unexpected alias.fish format)' >&2
            return 1
        end
    end

    # Bash-style / POSIX-style: `alias NAME` prints the wrapped command (no `=`).
    if test (count $argv) -eq 1
        set -l a $argv[1]
        if string match -q '*=*' -- $a
            __fish_stock_alias $argv
        else if string match -q -- '-*' $a
            __fish_stock_alias $argv
        else
            echo_alias $a
        end
    else
        __fish_stock_alias $argv
    end
end
