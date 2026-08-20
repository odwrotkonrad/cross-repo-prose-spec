# Feature: Session lifetime

<!--[>] 🤖🤖 -->

## As a session user

Attaches and detaches at will. Does not manage pod lifecycle by hand.

### Closing the terminal is not ending the session (implemented)

I want the pod still running after the terminal closes and session-attach
reaching it again,
so that detaching is the default, stopping is deliberate.

### Long agent work runs while I am away (implemented)

I want a detached task continuing and its output waiting on reattach,
so that the terminal is not a leash.

<!--[<] 🤖🤖 -->
