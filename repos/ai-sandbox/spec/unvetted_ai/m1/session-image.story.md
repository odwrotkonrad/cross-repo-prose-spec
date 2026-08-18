# Feature: Session image

<!--[>] 🤖🤖 -->

## As a sandbox operator

Builds and ships the base image. Does not configure tools in it.

### One image serves every session (todo)

I want every session pod running the one built session image, with no
per-session build,
so that there is a single artifact to reason about.

### A session start pulls nothing (todo)

I want a session starting from the image already on the node,
so that creation is not gated on a registry.

### The base holds only what a session cannot install itself (todo)

I want zsh, the session user's home and che present, with no configuration-image
content baked in,
so that the base changes rarely.

## As a session user

Works in the session shell. Does not build images.

### The shell is the session user's own (todo)

I want the session shell running as the session user in that user's home,
so that nothing runs as root by default.

### Root is one sudo away when the work needs it (todo)

I want passwordless sudo for the session user,
so that the pod boundary carries the risk instead of a password prompt.

### Root-group files are readable without escalation (todo)

I want the session user in the root group,
so that ordinary work does not reach for sudo.

<!--[<] 🤖🤖 -->
