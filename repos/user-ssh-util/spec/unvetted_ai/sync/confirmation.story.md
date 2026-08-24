# Feature: Rotation Confirmation

<!-- [>] 🤖🤖 -->

A scheduled rotation asks before it acts. Naming a key on the command line is
itself the confirmation.

## As a key owner

Wants to know before a key is replaced, without answering questions forever.

### A due key asks first (implemented)

I want each key past its period to prompt by name, stating which platforms the
old key will be revoked from,
so that a rotation is never a surprise.

### Declining leaves everything untouched (implemented)

I want a declined prompt to skip that key entirely: no new key, no publish, no
revoke, and the reason reported,
so that answering no costs nothing.

### Each key is asked separately (implemented)

I want one prompt per due key,
so that rotating one key never implies rotating another.

### `--yes` answers every prompt (implemented)

I want a flag that confirms all due rotations up front,
so that a trusted run needs no keystrokes.

## As an operator

Runs the tool unattended, and sometimes rotates on demand.

### No terminal means no rotation (implemented)

I want a run with no tty to skip rotation rather than assume an answer,
so that cron and CI never rotate a key nobody approved.

### `--force-rotate-keys` rotates named keys immediately (implemented)

I want `--force-rotate-keys=a,b` to rotate exactly those keys regardless of
their period, without prompting,
so that an urgent rotation is one command.

### A misspelled key name fails loudly (implemented)

I want `--force-rotate-keys` naming an undeclared key to exit with an error,
so that a typo never reports success having rotated nothing.

### A forced key needs no rotation rule (implemented)

I want forcing to work on a key whose type has no configured period,
so that a key excluded from the schedule can still be rotated on demand.

<!-- [<] 🤖🤖 -->
