# Feature: renderTemplates Missing Sources

<!-- [>] 🤖🤖 -->

A template pulls in sources three ways: the file a leaf points at, path-reading
funcs (`localFile`, `frontmatter`, `readBody`, `renderMarkdown`), and `@<path>`
include lines when a dest opts in with `renderReferencedFiles`. Each fails loudly
on an absent source. A typo never ships as wrong output.

One passthrough: without `renderReferencedFiles`, an `@<path>` line is content.
Claude and AGENTS files carry native `@` imports their own reader resolves, so
che writes them verbatim, warning per unresolved line.

## As a repo owner

Owns the templates and the docs they generate. Wants typos caught before the
doc ships.

### One broken template not costing the whole pass (tested)

I want a leaf with a missing source reported by path, healthy leaves still
rendering, che exiting non-zero,
so that one typo does not hide the state of every other template.

### A mistyped path in a template surfacing instead of rendering empty (tested)

I want `localFile`, `frontmatter`, `readBody` or `renderMarkdown` on an absent
path to fail the render naming template and path, no dest written, the doc
readers erroring on their own for an absent path under the repo root,
so that an empty section is never mistaken for an empty source.

### A broken doc include caught before the doc ships (tested)

I want an `@<path>` line to an absent file, under `renderReferencedFiles`, to
fail the render naming line and path, dest not written, tilde includes held to
the same standard,
so that a shipped doc never silently drops a section.

### A tilde include finding the file the rest of che would load (tested)

I want `@~/<path>` resolved under the repo tree's `root/_home/` marker, same as
every other che op,
so that one path means one file everywhere.

### A native @-import reaching the agent file untouched (tested)

I want a dest without `renderReferencedFiles` to write `@<path>` lines
verbatim, no source lookup gating the write,
so that a reader resolving its own imports keeps working.

### A typo in a native @-import visible without breaking the render (tested)

I want an absent file behind such a line to warn naming dest and line, dest
still written, resolvable lines quiet,
so that a broken import is noticed without failing a doc che cannot judge.

### Prose that opens with @ read as prose (tested)

I want a body line starting with `@` and containing whitespace treated as
content, no missing-source error,
so that writing about an `@` handle does not break a render.

### A broken include never mistaken for work already done (implemented)

I want a dest whose render would fail on a missing `@`-include reported as
unsettled,
so that a cached settled state cannot skip a render that would fail.

<!-- [<] 🤖🤖 -->
