alias __av_test_gs='git status'
set --local act (echo_alias __av_test_gs | string collect)
set act (string trim -- $act | string collect)
assert_eq 'git status' "$act" 'simple alias'
functions --erase __av_test_gs

alias __av_test_ll='ls -la'
set act (alias_value __av_test_ll | string collect)
set act (string trim -- $act | string collect)
assert_eq 'ls -la' "$act" 'alias with flags'
functions --erase __av_test_ll

alias __av_test_gc='git commit -m'
set act (alias_value __av_test_gc | string collect)
set act (string trim -- $act | string collect)
assert_eq 'git commit -m' "$act" 'alias with subcommand'
functions --erase __av_test_gc
