# Feature: Repo-Dest Render Permissions

<!-- [>] 🤖🤖 -->

`renderTemplates` accepts `chmod` on any node, and host dests honour it. Repo
dests ignored it and wrote one hardcoded mode, so a rendered file could never be
executable. That blocked authoring a script once and rendering it into each
consumer: the output arrived unrunnable.

## As a config author

Declares renders in `che.yml`. Sets no permissions by hand after a render.

### Render an executable file, not just a readable one (todo)

I want `chmod` honoured on repo dests as it already is on host dests,
so that a script authored once can be rendered into a repo and run without a
manual chmod.

### Ordinary rendered docs keep their existing mode (todo)

I want a dest declaring no `chmod` to keep the group-writable default,
so that adding this capability changes no existing render.

### A re-render repairs a mode that drifted (todo)

I want the mode applied on every render, not only when the file is created,
so that an existing dest converges on the declared permissions like the rest of
che's operations.

### A malformed mode fails loudly (todo)

I want a non-octal `chmod` to error naming the dest and the bad value,
so that a typo surfaces at render time instead of yielding a silently wrong mode.

<!-- [<] 🤖🤖 -->
