#!/usr/bin/env fish
# Usage: fish --no-config tests/run_tests.fish
# (--no-config avoids host config aliases affecting tests that call `alias`.)

set --local here (dirname (status filename))
set --local root (dirname $here)
set -g AV_ROOT $root
set fish_function_path $root/functions $fish_function_path

set -g _av_pass 0
set -g _av_fail 0

function assert_eq --description 'Assert two strings are equal'
    set --local exp $argv[1]
    set --local act $argv[2]
    set --local name $argv[3]
    if test "$exp" = "$act"
        echo "[PASS] $name"
        set _av_pass (math $_av_pass + 1)
    else
        echo "[FAIL] $name (expected: '$exp' got: '$act')"
        set _av_fail (math $_av_fail + 1)
    end
end

function assert_int_eq --description 'Assert two integers are equal'
    set --local exp $argv[1]
    set --local got $argv[2]
    set --local name $argv[3]
    if test "$exp" -eq "$got"
        echo "[PASS] $name"
        set _av_pass (math $_av_pass + 1)
    else
        echo "[FAIL] $name (expected exit: $exp got: $got)"
        set _av_fail (math $_av_fail + 1)
    end
end

function assert_stderr_match --description 'Assert stderr contains substring'
    set --local needle $argv[1]
    set --local err $argv[2]
    set --local name $argv[3]
    if string match -q "*$needle*" -- $err
        echo "[PASS] $name"
        set _av_pass (math $_av_pass + 1)
    else
        echo "[FAIL] $name (stderr missing '$needle', got: '$err')"
        set _av_fail (math $_av_fail + 1)
    end
end

function assert_stdout_match --description 'Assert stdout contains substring'
    set --local needle $argv[1]
    set --local out $argv[2]
    set --local name $argv[3]
    if string match -q "*$needle*" -- $out
        echo "[PASS] $name"
        set _av_pass (math $_av_pass + 1)
    else
        echo "[FAIL] $name (stdout missing '$needle', got: '$out')"
        set _av_fail (math $_av_fail + 1)
    end
end

for t in $here/test_*.fish
    source $t
end

set --local total (math $_av_pass + $_av_fail)
echo "$_av_pass/$total tests passed."

if test $_av_fail -gt 0
    exit 1
end
exit 0
