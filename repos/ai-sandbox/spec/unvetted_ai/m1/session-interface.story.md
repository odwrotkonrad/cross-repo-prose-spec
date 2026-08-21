# Feature: Session interface

<!--[>] 🤖🤖 -->

## As a session user

Creates, attaches to and names sessions. Builds no images, bootstraps no
cluster.

### One command from nothing to a working session (implemented)

I want session-attach creating a session when none exists and attaching to
it,
so that the first run needs no setup step.

### No prompt when the choice is obvious (implemented)

I want session-attach going straight to the only running session,
so that the common case costs one keystroke.

### The right session out of many (implemented)

I want session-attach offering a picker when several sessions run and
attaching to the picked one,
so that many sessions stay navigable.

### Past work stays inspectable (implemented)

I want session-attach offering stopped sessions on request, the picked one's
data readable,
so that stopping is not losing.

### A second session without disturbing the first (tested)

I want session-create always making a new session, existing ones untouched,
so that parallel work is one command.

### The full inventory at a glance (tested)

I want session-ls listing running sessions, stopped ones on request,
so that nothing runs unaccounted for.

### Stopping frees the machine, not the work (tested)

I want session-stop shutting the pod down and keeping its data,
so that reclaiming resources is not destructive.

### Sessions are addressable by a name a human recalls (tested)

I want a new session named a random pronounceable mnemonic, not a timestamp,
so that sessions get names without anyone supplying one.

### Names read as everyday words (implemented)

I want names built from an adjective, a colour, a creature or a thing,
so that a name can be said out loud.

### No two names are confusable (tested)

I want auto-named sessions differing in more than a trailing character, even
two created back to back,
so that listings are unambiguous.

### A session takes the name the work deserves (implemented)

I want session-rename giving a new name that session-ls and session-attach
both honour,
so that a mnemonic can become a purpose.

### Renaming costs nothing (tested)

I want a renamed session keeping its data,
so that naming is free at any point.

### A rename interrupts nothing (todo)

I want a renamed session's pod left running, not recreated,
so that a running task survives the rename.

### A rename cannot overwrite another session (tested)

I want a rename onto an existing name refused, both names kept,
so that a collision fails loudly.

## As a sandbox operator

Owns the make interface. Does not decide session naming.

### The session verbs read as one group (implemented)

I want every session verb prefixed session-, image builds and cluster
bootstrap outside that prefix,
so that the interface is legible in one listing.

<!--[<] 🤖🤖 -->
