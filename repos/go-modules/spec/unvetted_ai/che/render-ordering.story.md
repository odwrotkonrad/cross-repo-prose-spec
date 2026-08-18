# Feature: A Generated File Waits For What It Includes

<!-- [>] 🤖🤖 -->

Some generated files consume other generated files. `AGENTS.md` is rendered
from a template that `@`-includes four dests produced by the same pass:

```
@assets/docs-agents/purpose.md      rendered earlier, resolves
@assets/data/conventions.md         rendered earlier, resolves
@assets/data/makefile.agents.md     rendered later,   fails
@assets/data/repo-structure.md      rendered later,   fails
```

che renders in the order items appear in the resolved spec, which says nothing
about that dependency. Two of the four happen to come first and work; two come
later and do not.

Every one of those files is gitignored, so a working copy always carries them
from an earlier run and the render succeeds. Only a clean checkout has none of
them, which is why this reached CI and nowhere else.

It was invisible for as long as a missing include was written verbatim.
[renderTemplates missing sources](render-templates-missing-sources.story.md)
makes it an error, correctly, and turns a silent ordering bug into a failed
render. This feature is the other half: the order has to be right, not merely
checked.

Ordering the blocks by hand in each repo's `che.yml` was considered and
rejected. It states the dependency implicitly, in one file per repo, maintained
by whoever notices, and it breaks silently the next time someone adds an
include. That is how this survived in the first place. The templates already
say what they depend on; che should read it.

## As a repo owner

Owns a repo's `che.yml` and its generated docs. Adds includes, does not order
renders.

### A generated file rendering after what it includes (todo)

I want a template whose dest opts into `renderReferencedFiles` and includes a
path another item renders to have that file rendered first, the including file
resolving it, a clean checkout rendering as well as a working copy,
so that generated docs build on CI, not only where stale artifacts survive.

### Order taken from the templates, not from block position (todo)

I want the dependency to decide the order when spec order contradicts it, moving
either block in `che.yml` changing nothing,
so that adding an include never requires reordering a file by hand.

### A repo with no cross-render includes unchanged (todo)

I want a profile whose templates include nothing another item renders to render
in spec order with no output difference,
so that ordering costs nothing where it is not needed.

### An include of a file this pass does not render left to existing rules (todo)

I want an `@`-include naming a path no item produces to create no ordering edge,
the file expected on disk and failing or warning exactly as
[missing sources](render-templates-missing-sources.story.md) specifies,
so that one feature does not quietly redefine another's behavior.

### A cycle failing instead of picking a winner (todo)

I want two dests each including the other to fail the render naming the files in
the cycle, exiting non-zero with neither dest written from a guessed order,
so that an impossible dependency is reported, not resolved arbitrarily.

### A dry run predicting the order a real run takes (todo)

I want `--dry-run` to report the same order the real render would use, a dest a
real run would resolve not reported as failing,
so that a dry run stays trustworthy once ordering exists.

<!-- [<] 🤖🤖 -->
