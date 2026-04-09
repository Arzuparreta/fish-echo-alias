function _alias_value_get_body --description 'Print raw `functions <name>` output'
    set --local name $argv[1]
    if not functions --query -- $name
        echo "echo_alias: '$name' is not a defined function" >&2
        return 1
    end
    functions -- $name
end
