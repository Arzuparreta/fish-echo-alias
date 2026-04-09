alias __av_test_q="echo 'hello world'"
set --local act (alias_value __av_test_q | string collect)
set act (string trim -- $act | string collect)
assert_eq "echo 'hello world'" "$act" 'command containing quotes'
functions --erase __av_test_q

function __av_test_man
    git status $argv
end
set act (alias_value __av_test_man | string collect)
set act (string trim -- $act | string collect)
assert_eq 'git status' "$act" 'manual function ending in argv'
functions --erase __av_test_man

function __av_test_multi --description 'alias __av_test_multi=joined'
    printf '%s\n' 'first line'
    printf '%s\n' 'second line' $argv
end
set --local line1 "printf '%s\n' 'first line'"
set --local line2 "printf '%s\n' 'second line'"
set --local exp (string join \n -- $line1 $line2 | string collect)
set act (alias_value __av_test_multi | string collect)
set act (string trim -- $act | string collect)
assert_eq "$exp" "$act" 'multiline manual alias-style body'
functions --erase __av_test_multi
