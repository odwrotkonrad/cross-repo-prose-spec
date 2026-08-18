# Feature: history completion menu

<!-- [>] 🤖🤖 -->

## As a developer

Reruns past commands constantly, retypes none of them.

### Past commands recalled from what is already typed (implemented)

I want Up or Down opening a heading-less menu, newest first and deduped, filling
the terminal rows below the prompt with 2 blank rows left at the bottom, the
whole buffer substring-filtering case-insensitively, accepting an entry
replacing the whole buffer, entries spanning more than one row or matching an
ignore-hints regex omitted, and Up/Down moving the selection inside the menu,
so that a command run once is never typed twice.

### The recalled entry stands alone on the line (implemented)

I want the entry replacing the entire buffer wherever the cursor sits, no typed
word surviving before or after it, and the buffer and cursor untouched when
nothing matches,
so that a recall is never mixed with the fragment that found it.

### The closest match comes first (implemented)

I want exact-case prefix matches ranked first, case-insensitive prefix second,
case-insensitive substring last, newest first and deduped within each tier,
so that the intended command is the top entry, not the newest coincidence.

<!-- [<] 🤖🤖 -->
