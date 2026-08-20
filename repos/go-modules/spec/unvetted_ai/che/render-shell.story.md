# Feature: Shell Commands In Templates

<!-- [>] 🤖🤖🤖 -->

A `shell` template function runs a command at render time and substitutes its
stdout, so a template can ask a tool the host already has (`glab variable get`)
instead of che growing a backend per source. Fetched values are configuration,
not credentials: `secret` stays for `op://` and `gcp://`, and `skipVariables`
skips templates that shell out the way `skipSecrets` skips templates that
resolve secrets.

## As a template author

Writes `*.tpl` files che renders. Uses stock gomplate syntax.

### A command's output lands in the template (implemented)

I want `{{ shell "<command>" }}` to run the command with `-c` under the user's
shell (`$SHELL`, else the login shell from the user database unless `nologin`,
`false` or not executable, else `sh`), in the repo root with the process env
(exported effective env included), substituting stdout with the trailing
newline trimmed,
so that a template seeds a value (`glab variable get -g konradodwrot
GRP_KO_VAR_PROSE_REF` into `.env`) from a tool the host already authenticates.

### A failing command fails the render by name (tested)

I want a non-zero exit to fail the render naming template, command, exit status and stderr,
never substituting partial output,
so that an unauthenticated or missing tool is a loud error, not an empty line.

## As a config author

Runs renders on hosts and in CI with differing tools available.

### Templates that shell out can be skipped as a set (tested)

I want `options.renderTemplates.skipVariables` (flag, env var, standard cascade)
to skip every template with a `shell` call, each skipped dest logged with the
option's name, mirroring `skipSecrets`,
so that a host without the tool (a credential-less CI job, a dry run) renders
everything else.

### Secrets and variables skip independently (tested)

I want `skipSecrets` to match only `op://` and `gcp://` refs and `skipVariables`
only `shell` calls, a template carrying both skipped when either is on,
so that each option names exactly what it withholds.

<!-- [<] 🤖🤖🤖 -->
