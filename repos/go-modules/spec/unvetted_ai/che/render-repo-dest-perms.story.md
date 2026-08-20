# Feature: Repo-Dest Render Permissions

<!-- [>] 🤖🤖 -->

`renderTemplates` accepts `chmod` on any node, and host dests honour it. Repo
dests ignored it and wrote one hardcoded mode, so a rendered file could never be
executable. That blocked authoring a script once and rendering it into each
consumer: the output arrived unrunnable.

## As a config author

Declares renders in `che.yml`. Sets no permissions by hand after a render.

### Render an executable file, not just a readable one (tested)

I want `chmod` honoured on repo dests as it already is on host dests,
so that a script authored once can be rendered into a repo and run without a
manual chmod.

### Ordinary rendered docs keep their existing mode (tested)

I want a dest declaring no `chmod` to keep the group-writable default,
so that adding this capability changes no existing render.

### A re-render repairs a mode that drifted (implemented)

I want the mode applied whenever a render writes the dest, not only when the
file is created,
so that an existing dest converges on the declared permissions like the rest of
che's operations.

### A drifted mode repaired without a content change (todo)

I want a dest whose content is already current but whose mode differs from the
declared `chmod` to be chmodded on the next render,
so that a manual chmod never outlives a render.

### A malformed mode fails loudly (tested)

I want a non-octal `chmod` to error naming the dest and the bad value,
so that a typo surfaces at render time instead of yielding a silently wrong mode.

<!-- [<] 🤖🤖 -->
