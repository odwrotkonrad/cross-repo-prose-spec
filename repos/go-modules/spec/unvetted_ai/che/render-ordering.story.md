# Feature: A Generated File Waits For What It Includes

<!-- [>] 🤖🤖 -->

Some generated files include other generated files. `AGENTS.md` renders from a
template that `@`-includes four dests from the same pass:

```
@assets/docs-agents/purpose.md      rendered earlier, resolves
@assets/data/conventions.md         rendered earlier, resolves
@assets/data/makefile.agents.md     rendered later,   fails
@assets/data/repo-structure.md      rendered later,   fails
```

che renders in resolved spec order, which knows nothing of that dependency. Two
of the four happen to come first and work, two come later and fail.

All four are gitignored, so a working copy carries them from an earlier run and
the render passes. Only a clean checkout lacks them, which is why this surfaced
in CI and nowhere else.

It stayed invisible while a missing include was written verbatim.
[renderTemplates missing sources](render-templates-missing-sources.story.md)
makes that an error, turning a silent ordering bug into a failed render. This
feature is the other half: the order has to be right, not merely checked.

Hand-ordering the blocks in each repo's `che.yml` was rejected. It encodes the
dependency implicitly, per repo, maintained by whoever notices, and breaks
silently the next time someone adds an include. That is how this survived. The
templates already say what they depend on, che should read it.

## As a repo owner

Owns a repo's `che.yml` and its generated docs. Adds includes, does not order
renders.

### A generated file rendering after what it includes (tested)

I want a template whose dest opts into `renderReferencedFiles` and includes a
path another item renders to get that file rendered first, a clean checkout
rendering like a working copy,
so that generated docs build on CI, not only where stale artifacts survive.

### Order taken from the templates, not from block position (tested)

I want the dependency to win when spec order contradicts it, moving either
block in `che.yml` changing nothing,
so that adding an include never means reordering a file by hand.

### A repo with no cross-render includes unchanged (implemented)

I want a profile whose templates include nothing another item renders to render
in spec order with identical output,
so that ordering costs nothing where it is not needed.

### An include of a file this pass does not render left to existing rules (tested)

I want an `@`-include naming a path no item produces to add no ordering edge,
the file expected on disk and failing or warning exactly as
[missing sources](render-templates-missing-sources.story.md) specifies,
so that one feature does not quietly redefine another.

### A cycle failing instead of picking a winner (tested)

I want two dests including each other to fail the render naming the files in
the cycle, exiting non-zero, neither dest written from a guessed order,
so that an impossible dependency is reported, not resolved arbitrarily.

### A dry run predicting the order a real run takes (implemented)

I want `--dry-run` to report the order the real render would use, a dest a real
run would resolve not reported as failing,
so that a dry run stays trustworthy once ordering exists.

<!-- [<] 🤖🤖 -->
