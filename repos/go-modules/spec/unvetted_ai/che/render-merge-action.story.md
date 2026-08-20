# Feature: A rendered value decides whether it overwrites the existing one

<!-- [>] 🤖🤖 -->

`writeType: mergeUpsert` unions a rendered `KEY=VALUE` file under the existing
dest and keeps the existing value for a key both have. Right for a knob the
user set by hand, wrong for a value the template fetched: a bumped group
variable or a rotated secret never reaches `.env` once a first render wrote
it. The template decides per value, through a pipe after the expression:
`{{ shell "..." | alwaysUpdate }}` overwrites, `{{ shell "..." | keepIfExisting }}`
keeps. The same two actions follow `secret`. Unpiped, a `shell` or `secret`
value updates, everything else keeps, so the default matches what each kind
of value is: fetched values track their source, typed values belong to the
user.

## As a template author

Writes `.env.tpl`. Wants fetched values fresh and hand-set ones untouched.

### A fetched value overwrites by default (tested)

I want a key whose value comes from `{{ shell "..." }}` or
`{{ secret "..." }}` to replace the existing value in the dest on every
`mergeUpsert` render, with no pipe written,
so that `.env` follows the GitLab variable or vault item it was seeded from,
and the default reads the way I mean it.

### A pipe makes the action explicit (tested)

I want `| alwaysUpdate` and `| keepIfExisting` accepted after any value expression
(`shell`, `secret`, a literal through `printf`), the pipe naming the merge
action for that key alone,
so that one template mixes a tracked value and a one-time seed line by line.

### A typed value keeps by default (tested)

I want a line with no template expression, or an unpiped expression other
than `shell` and `secret`, to keep the existing value as `mergeUpsert` does
today,
so that a knob I set in `.env` survives every render unless the template
says otherwise.

### The action names itself on error (tested)

I want an unknown action (`| alwaysUpdat`) to fail the render naming the
template and the function, as any undefined template function does,
so that a typo cannot silently fall back to either behaviour.

## As a config author

Owns a repo's `che.yml`. Changes no template to get the default.

### The action is invisible in the rendered file (tested)

I want the pipe to leave no trace in the dest: the written line is
`KEY=VALUE`, the action consumed by the merge,
so that `.env` stays a plain env file any shell sources.

### Other writeTypes are unaffected (tested)

I want `alwaysUpdate` and `keepIfExisting` to be no-ops under every writeType but
`mergeUpsert`, the value passing through unchanged,
so that a template shared between an env dest and a plain file renders the
same text in both.

<!-- [<] 🤖🤖 -->
