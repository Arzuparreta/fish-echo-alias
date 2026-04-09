function _alias_value_parse --description 'Extract command string from alias body'
    read -z --local raw
    set --local lines (string split \n -- $raw)
    set --local parts

    # Same structural skips as validate: drop preamble # lines, wrapper, end.
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
        set --append parts $t
    end

    # Join body lines; aliases rarely span lines but manual defs may.
    # string collect keeps embedded newlines as one value for later assigns.
    set --local cmd (string join \n -- $parts | string collect)
    # Anchor $ at end only so a literal $argv inside the command is kept.
    set cmd (string replace -r '\s*\$argv\s*$' '' -- $cmd | string collect)
    set cmd (string trim -- $cmd | string collect)

    # fish alias may store the whole rhs in one pair of quotes; peel one layer.
    set --local L (string length -- $cmd)
    if test "$L" -ge 2
        set --local a (string sub -s 1 -l 1 -- $cmd)
        set --local b (string sub -s $L -l 1 -- $cmd)
        if test \( "$a" = \' -a "$b" = \' \) -o \( "$a" = '"' -a "$b" = '"' \)
            set cmd (string sub -s 2 -l (math $L - 2) -- $cmd)
        end
    end

    printf '%s' "$cmd"
end
