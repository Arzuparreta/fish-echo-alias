complete -c echo_alias -f -a '(alias | string match -r "^alias (\S+)" --groups-only)' \
    -d 'alias name'
