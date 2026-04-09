# fish-echo-alias

**Fish has no builtin that prints what an alias runs** — only `functions name` (full
definition) or `alias` with no args (list everything). This plugin fills that gap: you
get the **command string** behind a name, as plain text, for piping, scripting, or
quick inspection — the same idea as “echo what this alias expands to”.

**Requires fish ≥ 3.1** (`string` built-in, `functions --query`).

On each push or pull request to `main`/`master`, [GitHub Actions](.github/workflows/test.yml)
runs `fish --no-config tests/run_tests.fish` on Ubuntu.

## Install

### Fisher

```fish
fisher install YOUR_USER/fish-echo-alias
```

For a **local** clone (no remote):

```fish
fisher install /absolute/path/to/fish-echo-alias
```

### Manual

**Prepend** this repo’s `functions` directory to `fish_function_path` (so the bundled
`alias` can shadow fish’s) and add `completions` to `fish_complete_path`:

```fish
set -l root ~/path/to/fish-echo-alias
set fish_function_path $root/functions $fish_function_path
set fish_complete_path $root/completions $fish_complete_path
```

Restart the shell or run `source ~/.config/fish/config.fish`.

## Usage — resolve an alias to a string

Fish cannot treat a **name** as dynamic text for the plain `echo` builtin; use command
substitution when you want the value on stdout or in a variable.

**Canonical helper** (matches the project name):

```fish
alias desktop-ruben='100.91.167.48'

echo_alias desktop-ruben
# → 100.91.167.48

echo (echo_alias desktop-ruben)
# same line on stdout, for piping / variables
```

**Bash-style** (requires this plugin’s `alias` ahead of fish’s on `fish_function_path`):

```fish
alias desktop-ruben='100.91.167.48'
alias desktop-ruben
# → 100.91.167.48
```

**Legacy name** `alias_value` is a thin wrapper around `echo_alias` (same behavior).

```fish
echo_alias --help   # usage on stdout, exit 0 (also `-h`, `-help`)
echo_alias          # same
```

Errors go to **stderr** with the `echo_alias:` prefix; exit code **1**.

## Fish alias / function name rules

In Fish, `alias` creates a **function**; the alias **name** is the function name. There is no
separate alias namespace. Official reference: [Shell variable and function names](https://github.com/fish-shell/fish-shell/blob/master/doc_src/language.rst) (`language.rst`) and [function](https://github.com/fish-shell/fish-shell/blob/master/doc_src/cmds/function.rst) (`function.rst`).

**Function names** (what you pass to `echo_alias`):

- Must not be **empty**.
- Must not **begin with** `-` (hyphen).
- Must not contain **`/`** (slash).
- **All other characters are allowed**, including spaces — quote the name on the command line when needed (e.g. `echo_alias 'my cmd'`).
- Must not be a **reserved word** (e.g. `if`, `set`, `end`, `while`, …); see `function` docs for the full list.

**Variable names** are stricter (letters, digits, and `_` only); that does **not** apply to
function/alias names.

`echo_alias` forwards the given name to `functions` as Fish defines it; it does not apply a
stricter name grammar of its own. If you add wrapper syntax later (subcommands, operators),
parse that **before** treating a token as a bare alias name — Fish already allows many
characters (including `-` in the middle, e.g. `foo-bar`) that you might want to reserve for
your own CLI.

## Limitations

- The wrapped `alias` loads fish’s stock `alias` from `$__fish_data_dir/functions/alias.fish`
  at first use. If that file’s first line changes in a future fish release, report an
  issue or pin a compatible fish version.
- Fish’s bare `alias` listing uses `functions -n`, so it does **not** show aliases
  whose names start with `_` (same as stock fish).
- If the function body was edited by hand, only the **current** body is visible — not
  the original `alias name='...'` text.
- **Multiline** alias-style bodies are returned as a single string with embedded
  newlines.
- Functions that do not follow alias shape are reported as **not an alias**.
- **No** support for alias definitions that use `--on-*` event handlers.

## License

MIT. See [LICENSE](LICENSE).
