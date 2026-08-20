# Feature: renderTemplates Missing Sources

<!-- [>] 🤖🤖 -->

A template references sources three ways: the template file a leaf points at,
in-template funcs reading a path (`localFile`, `frontmatter`, `readBody`,
`renderMarkdown`), and `@<path>` include lines inlined when a dest opts in with
`renderReferencedFiles`. Every one of them fails loudly when its source is
absent, so a typo never ships as silently wrong output.

The one deliberate passthrough: without `renderReferencedFiles`, an `@<path>`
line is content, not an include. Claude and AGENTS files carry native `@`
imports resolved by their own reader, so che leaves them verbatim. Verbatim is
not unexamined: che warns per unresolved line, so a typo is visible without
failing a dest whose reader resolves the import itself.

## As a repo owner

Owns the templates and the docs they generate. Wants a typo caught before the
doc ships.

### One broken template not costing the whole pass (tested)

I want a leaf whose source path does not exist reported as a failure naming its
path, a healthy leaf still rendering and che exiting non-zero,
so that one typo does not hide the state of every other template.

### A mistyped path in a template surfacing instead of rendering empty (tested)

I want `localFile`, `frontmatter`, `readBody` or `renderMarkdown` on an absent
path to fail the render naming the template and the missing path, no dest
written, the doc readers erroring on their own when handed an absent path under
the repo root,
so that an empty section is never mistaken for an empty source.

### A broken doc include caught before the doc ships (tested)

I want a dest opting into `renderReferencedFiles` whose body carries an
`@<path>` line to an absent file to fail the render naming the include line and
the path, the dest not written, a tilde include held to the same standard,
so that a shipped doc never contains a silently dropped section.

### A tilde include finding the file the rest of che would load (tested)

I want an `@~/<path>` line resolved under the repo tree's `root/_home/` home
marker, matching the marker every other che op uses,
so that one path means one file across every op.

### A native @-import reaching the agent file untouched (tested)

I want a dest not opting into `renderReferencedFiles` to write its `@<path>`
lines verbatim with no source lookup gating the write,
so that a reader resolving its own imports keeps working.

### A typo in a native @-import visible without breaking the render (tested)

I want an absent file behind such a line to warn naming the dest and the
unresolved line, the dest still written, a resolvable line staying quiet,
so that a broken import is noticed without failing a doc che cannot judge.

### Prose that opens with @ read as prose (tested)

I want a body line starting with `@` and carrying whitespace left as content
with no missing-source error,
so that writing about an `@` handle does not break a render.

### A broken include never mistaken for work already done (implemented)

I want a dest whose render would fail on a missing `@`-include reported as
unsettled,
so that a cached settled state cannot skip a render that would fail.

<!-- [<] 🤖🤖 -->
