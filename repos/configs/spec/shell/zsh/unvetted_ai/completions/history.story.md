# Feature: history completion menu

<!-- [>] 🤖🤖 -->

## As a developer

Reruns past commands constantly, retypes none of them.

### Past commands recalled from what is already typed (implemented)

I want Up or Down opening a heading-less menu, newest first, deduped, filling
the rows below the prompt minus 2 blank rows at the bottom, the whole buffer
substring-filtering case-insensitively, accepting an entry replacing the whole
buffer, entries spanning more than one row or matching an ignore-hints regex
omitted, Up/Down moving the selection inside the menu,
so that a command run once is never typed twice.

### The recalled entry stands alone on the line (implemented)

I want the entry replacing the entire buffer wherever the cursor sits, no
typed word surviving before or after it, buffer and cursor untouched when
nothing matches,
so that a recall never mixes with the fragment that found it.

### The closest match comes first (implemented)

I want exact-case prefix matches first, case-insensitive prefix second,
case-insensitive substring last, newest first and deduped within each tier,
so that the intended command tops the list, not the newest coincidence.

<!-- [<] 🤖🤖 -->
