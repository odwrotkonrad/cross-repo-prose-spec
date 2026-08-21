# Feature: Configuration update

<!--[>] 🤖🤖 -->

## As a session user

Updates configuration and keeps working. Does not author the profiles.

### One command carries a config change into the sandbox (tested)

I want session-update-config rebuilding the configuration image from the
changed sources,
so that updating is one verb.

### New sessions pick the change up (implemented)

I want running pods recreated on the rebuilt image and sessions created after
the update seeing the new configuration,
so that a change lands without a cluster rebuild.

### A working session is not reshaped underneath me (implemented)

I want a running pod never patched in place, the change arriving only by
recreation,
so that a session is on the old configuration or the new one, never between.

### Work in progress survives the update (tested)

I want the persisted paths intact in the recreated session,
so that updating never costs work.

### Updating config is fast (implemented)

I want the base image neither rebuilt nor re-pulled for a configuration-only
change,
so that cost matches the size of the change.

<!--[<] 🤖🤖 -->
