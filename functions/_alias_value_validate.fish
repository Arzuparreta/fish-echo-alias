function _alias_value_validate \
    --description 'Exit 0 if stdin looks like an alias-style function'
    read -z --local raw
    set --local lines (string split \n -- $raw)

    for line in $lines
        set --local t (string trim -- $line)
        test -z "$t"
        and continue
        if string match -qr '^function' -- $t
            if string match -q '*alias *' -- $t
                return 0
            end
        end
    end

    set --local content_lines
    for line in $lines
        set --local t (string trim -- $line)
        test -z "$t"
        and continue
        string match -qr '^#' -- $t
        and continue
        string match -qr '^function' -- $t
        and continue
        test "$t" = end
        and continue
        set --append content_lines $t
    end

    if test (count $content_lines) -eq 1
        set --local ln $content_lines[1]
        if string match -qr '\$argv\s*$' -- $ln
            return 0
        end
    end

    # stderr: echo_alias.fish prints the user-facing message on failure.
    return 1
end
