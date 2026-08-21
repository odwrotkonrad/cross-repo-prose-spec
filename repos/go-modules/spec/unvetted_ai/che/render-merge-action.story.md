# Feature: A rendered value decides whether it overwrites the existing one

<!-- [>] 🤖🤖 -->

`writeType: mergeUpsert` unions a rendered `KEY=VALUE` file under the existing
dest, existing value winning on a shared key. Right for a knob set by hand,
wrong for a fetched value: a bumped group variable or rotated secret never
reaches `.env` after the first render. A pipe decides per value:
`{{ shell "..." | alwaysUpdate }}` overwrites, `{{ shell "..." | keepIfExisting }}`
keeps, same after `secret`. Unpiped, `shell` and `secret` update, everything
else keeps: fetched values track their source, typed values belong to the user.

## As a template author

Writes `.env.tpl`. Wants fetched values fresh, hand-set ones untouched.

### A fetched value overwrites by default (implemented)

I want an unpiped `{{ shell "..." }}` or `{{ secret "..." }}` value to replace
the existing one on every `mergeUpsert` render,
so that `.env` follows the GitLab variable or vault item it was seeded from.

### A pipe makes the action explicit (tested)

I want `| alwaysUpdate` and `| keepIfExisting` accepted after any value
expression (`shell`, `secret`, a literal through `printf`), naming the merge
action for that key alone,
so that one template mixes tracked values and one-time seeds line by line.

### A typed value keeps by default (tested)

I want a line with no expression, or an unpiped expression other than `shell`
and `secret`, to keep the existing value,
so that a knob I set in `.env` survives every render unless the template says
otherwise.

### The action names itself on error (implemented)

I want an unknown action (`| alwaysUpdat`) to fail the render naming template
and function, like any undefined template function,
so that a typo cannot silently fall back to either behaviour.

## As a config author

Owns a repo's `che.yml`. Changes no template to get the default.

### The action is invisible in the rendered file (tested)

I want the written line to be `KEY=VALUE`, the pipe consumed by the merge,
so that `.env` stays a plain env file any shell sources.

### Other writeTypes are unaffected (tested)

I want `alwaysUpdate` and `keepIfExisting` to be no-ops under every writeType
but `mergeUpsert`, the value passing through unchanged,
so that a template shared between an env dest and a plain file renders the same
text in both.

<!-- [<] 🤖🤖 -->
