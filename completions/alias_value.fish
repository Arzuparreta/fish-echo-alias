complete -c alias_value -f -a '(alias | string match -r "^alias (\S+)" --groups-only)' \
    -d 'alias name'
