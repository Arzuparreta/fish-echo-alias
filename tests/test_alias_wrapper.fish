# `alias NAME` (no =) prints the same output as alias_value (plugin shadows stock alias).

alias __av_wrap_gs='git status'
set --local act (alias __av_wrap_gs | string collect)
set act (string trim -- $act | string collect)
assert_eq 'git status' "$act" 'alias <name> prints command string'
functions --erase __av_wrap_gs

alias __av_wrap_ip='100.91.167.48'
set act (alias __av_wrap_ip | string collect)
set act (string trim -- $act | string collect)
assert_eq '100.91.167.48' "$act" 'alias <name> with bare token body'
functions --erase __av_wrap_ip

function __av_wrap_plain
    echo hi
end
set --local efile (mktemp)
alias __av_wrap_plain 2>$efile
set --local st $status
read -z em <$efile
rm -f $efile
assert_int_eq 1 $st 'alias plain function exit code'
assert_stderr_match 'not an alias' "$em" 'alias plain function stderr'
functions --erase __av_wrap_plain

# fish 4.x prints ALIAS(1) in roff-style help; fish 3.x (Ubuntu CI) does not — both
# include this phrase from __fish_print_help.
set --local hout (alias -h 2>&1 | string collect)
assert_stdout_match 'alias - create' "$hout" 'alias -h still delegates to stock'

# Stock `alias` lists via `functions -n`, which omits names starting with `_`.
alias av_list_probe='true'
set --local lout (alias | string collect)
assert_stdout_match av_list_probe "$lout" 'alias with no args lists aliases'
functions --erase av_list_probe
