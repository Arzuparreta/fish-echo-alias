# Stderr from _alias_value_get_body runs inside command substitution and
# bypasses a parent 2> redirect; use a nested fish to capture it.
set --local efile (mktemp)
fish -c "set fish_function_path $AV_ROOT/functions \$fish_function_path; alias_value __av_test_unknown_xyz" \
    2>$efile
set --local st $status
set --local em (string collect <$efile)
rm -f $efile
assert_int_eq 1 $st 'unknown name exit code'
assert_stderr_match __av_test_unknown_xyz "$em" 'unknown name stderr'

function __av_test_plain
    echo hi
end
set efile (mktemp)
alias_value __av_test_plain 2>$efile
set st $status
read -z em <$efile
rm -f $efile
assert_int_eq 1 $st 'plain function exit code'
assert_stderr_match 'not an alias' "$em" 'plain function stderr'
functions --erase __av_test_plain

set --local uout (alias_value | string collect)
set st $status
assert_int_eq 0 $st 'no arguments exit code'
assert_stdout_match Usage "$uout" 'no arguments stdout'

set uout (alias_value --help | string collect)
set st $status
assert_int_eq 0 $st '--help exit code'
assert_stdout_match Usage "$uout" '--help stdout'

set uout (alias_value -h | string collect)
set st $status
assert_int_eq 0 $st '-h exit code'
assert_stdout_match Usage "$uout" '-h stdout'

set uout (alias_value -help | string collect)
set st $status
assert_int_eq 0 $st '-help exit code'
assert_stdout_match Usage "$uout" '-help stdout'
