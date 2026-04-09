function echo_alias --description 'Print the command string for a fish alias (what it runs)'
    if test (count $argv) -eq 0
        echo 'Usage: echo_alias <name>'
        return 0
    end
    switch "$argv[1]"
        case --help -h -help
            echo 'Usage: echo_alias <name>'
            return 0
    end
    if test (count $argv) -ne 1
        echo 'echo_alias: expected one <name> (see echo_alias --help)' >&2
        return 1
    end

    set --local name $argv[1]
    # Capture lines without piping, so \$status reflects _alias_value_get_body.
    set --local fn_lines (_alias_value_get_body $name)
    if test $status -ne 0
        return 1
    end
    set --local body (string join \n -- $fn_lines | string collect)

    printf '%s' "$body" | _alias_value_validate
    if test $status -ne 0
        echo "echo_alias: '$name' is a function, not an alias" >&2
        return 1
    end

    set --local result (printf '%s' "$body" | _alias_value_parse | string collect)
    printf '%s\n' "$result"
    return 0
end
