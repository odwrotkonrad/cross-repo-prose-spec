# Feature: Repo-Dest Render Permissions

<!-- [>] 🤖🤖 -->

`renderTemplates` accepts `chmod` on any node. Host dests honour it, repo dests
ignored it and wrote one hardcoded mode, so a rendered script was never
executable.

## As a config author

Declares renders in `che.yml`. Sets no permissions by hand after a render.

### Render an executable file, not just a readable one (tested)

I want `chmod` honoured on repo dests as on host dests,
so that a script authored once renders into a repo and runs without a manual
chmod.

### Ordinary rendered docs keep their existing mode (tested)

I want a dest declaring no `chmod` to keep the group-writable default,
so that this changes no existing render.

### A re-render repairs a mode that drifted (implemented)

I want the mode applied whenever a render writes the dest, not only on create,
so that an existing dest converges on the declared permissions like everything
else che does.

### A drifted mode repaired without a content change (todo)

I want a dest with current content but a mode differing from the declared
`chmod` chmodded on the next render,
so that a manual chmod never outlives a render.

### A malformed mode fails loudly (tested)

I want a non-octal `chmod` to error naming the dest and the bad value,
so that a typo surfaces at render time, not as a silently wrong mode.

<!-- [<] 🤖🤖 -->
