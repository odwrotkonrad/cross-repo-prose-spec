# Feature: Configuration update

<!--[>] 🤖🤖 -->

## As a session user

Updates configuration and keeps working. Does not author the profiles.

### One command carries a config change into the sandbox (tested)

I want session-update-config rebuilding the configuration image from the changed
sources,
so that updating is a single verb.

### New sessions pick the change up (implemented)

I want running pods recreated on the rebuilt image and sessions created after
the update seeing the new configuration,
so that a change lands without a cluster rebuild.

### A working session is not reshaped underneath me (implemented)

I want an existing session's home left unseeded and holding the configuration it
started with,
so that a mid-task update changes nothing in flight.

### Work in progress survives the update (tested)

I want the persisted paths intact in the recreated session,
so that updating never costs the work.

### Updating config is fast (implemented)

I want the base image neither rebuilt nor re-pulled for a configuration-only
change,
so that the cost matches the size of the change.

<!--[<] 🤖🤖 -->
