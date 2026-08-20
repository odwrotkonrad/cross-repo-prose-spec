# Feature: Env Interpolation In Che Specs

<!-- [>] 🤖🤖🤖 -->

`${{ env.NAME }}` and `${{ env.NAME || default }}` substitute environment
values into any scalar value of any che.yml: local, included, or sourced.
Mapping keys stay literal. Unset bare refs follow `options.envUnset:
error | empty`, default `error`. Existing `$VAR` dest expansion and
`runIf: ['env:NAME']` are untouched.

Lookup precedence at load, most specific last: the root spec's `.env` file,
the process env, the referenced spec's own top-level `env:`, the sourcing
ref's `env:` overlay. Same order
`assembleProfiles` already applies at runtime (`docs/spec.md`: the referenced
spec's `env:` merges under the ref's).

The effective env exports to the process around each profile's op execution,
so templates (gomplate `env.Getenv`), scripts, runIf and secret backends see
one env. Fetching values by running a tool at render time is
`render-shell.story.md`. Downstream use (one `PROSE_REF` group variable consumed everywhere) is
specified in `repos/shared/spec/.../ci/upstream-refs.story.md`,
`repos/shared/spec/.../dev-env/upstream-refs.story.md`,
`repos/infra/iac/spec/.../gitlab/ArtifactVersionVariablesBehavior.story.md` and
`repos/control/spec/.../sync/version-propagation.story.md`.

## As a config author

Writes che specs, parameterizes them at launch. Does not read che's internals.

### A launch env value lands anywhere in the spec (tested)

I want `${{ env.NAME }}` in any string value (globs, sources, dests, ctx,
options, package lists) replaced with the launch environment's value, several
refs and surrounding literal text allowed in one scalar,
so that one spec serves many invocations without forking or profile branches.

### The repo's .env is read without a shell reload (tested)

I want che to source `.env` beside the root che.yml (dotenv lines, `export`
prefix tolerated, missing file fine) into the launch env beneath the process
env, a value exported in the shell always winning over the file's,
so that a freshly rendered `.env` takes effect in the same shell and an
explicit export still overrides it.

### A fallback keeps the spec runnable with nothing exported (tested)

I want `${{ env.NAME || default }}` to substitute the default when `NAME` is
unset or empty, never erroring regardless of policy, the default taken
literally (everything after the first `||` up to `}}`, trimmed, never itself
interpolated),
so that a spec declares its own safe value and only overrides need exporting.

### An unset required var fails loud, with every gap at once (tested)

I want a bare `${{ env.NAME }}` on an unset or empty var to fail the load under
the default policy, all unset refs in the file collected into one error naming
the spec, each var and its YAML path (`/web/include/makeLinks/0`), and the
three ways out (export it, add `|| default`, set `options.envUnset: empty`),
so that one run reveals the full list, not one var per attempt.

### Only the profiles that run demand their vars (tested)

I want an unset bare ref to fail only when it sits in a profile selected for
the current run (by `--profiles`, auto-discovery, a sourced ref), a profile
skipped by selection or by `runIf` never erroring for its refs, top-level keys
outside any profile (`env:`, `options:`) always strict,
so that `che run --profiles a` never fails over a var only profile `b` needs.

### Unset tolerated when the spec says so (tested)

I want `options.envUnset: empty` (flag `--env-unset`, env `CHE_ENV_UNSET`,
user config, spec, default `error`, in that cascade) to resolve unset bare refs
to the empty string, the option itself read from the raw file before
interpolation so it is always a literal, like `validateSpec`,
so that optional parameterization needs no fallback on every site.

### The spec's env block feeds its own interpolation (tested)

I want the top-level `env:` values available to `${{ env.NAME }}` in the same
file, winning over the process env, each `env:` value itself expanded one
level from the env passed into the load (process env plus any ref overlay),
never from sibling keys,
so that a spec centralizes its defaults without export ceremony or ordering
rules.

### Values substitute as strings, structure stays intact (implemented)

I want substituted scalars to stay strings (`'${{ env.PORT }}'` never becomes
an int, `'${{ env.FLAG }}'` never a bool) and mapping keys (profile names) to
stay literal,
so that interpolation never rewrites the spec's shape.

### Anything short of the full form is left alone (tested)

I want only the complete `${{ env.NAME }}` / `${{ env.NAME || default }}` form
(`NAME` matching `[A-Za-z_][A-Za-z0-9_]*`, whitespace insignificant) rewritten,
every other `${{`, `$VAR`, `${VAR}` or `env.X` text passed through untouched,
so that existing specs and dest `$VAR` expansion keep their meaning.

## As a shared-profile consumer

Sources profiles from other repos, parameterizes each consumption.

### A sourced ref's env parameterizes the referenced spec (tested)

I want a sourced profile ref's `env:` overlay visible to the referenced
spec's own `${{ env.NAME }}` refs at load, winning over both the process env
and the referenced spec's own `env:` block,
so that one shared profile renders per-consumer without edits, and the ref
(the more specific site) always has the last word.

### Remote specs enforce the same contract (implemented)

I want included and sourced specs interpolated under the same rules, each
against its own `env:` block plus its ref's overlay, through the one load
path every spec takes,
so that a remote profile's requirements bind exactly like local ones.

### Discover reports what the tree requires (tested)

I want `che discover` to list, per spec including remote ones, every
`${{ env.* }}` ref, its default if any, and whether it is currently set,
unset requirements reported rather than failing the discovery,
so that the needed exports are known before anything runs.

## As a template author

Writes `*.tpl` files che renders. Uses stock gomplate syntax.

### Spec env reaches templates through gomplate env syntax (implemented)

I want the effective env (launch env, spec `env:`, ref overlay) exported to
the process around each profile's op execution, prior values restored after,
profiles executing sequentially, so `env.Getenv "NAME"` in any template
resolves it,
so that specs and templates read one env with no che-only syntax.

<!-- [<] 🤖🤖🤖 -->
