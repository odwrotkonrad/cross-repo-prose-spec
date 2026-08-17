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
[renderTemplates missing sources](render-templates-missing-sources.md) makes it
an error, correctly, and turns a silent ordering bug into a failed render. This
feature is the other half: the order has to be right, not merely checked.

Ordering the blocks by hand in each repo's `che.yml` was considered and
rejected. It states the dependency implicitly, in one file per repo, maintained
by whoever notices, and it breaks silently the next time someone adds an
include. That is how this survived in the first place. The templates already
say what they depend on; che should read it.

## Ordering

Scenario: a generated file that includes another generated file renders after it
  Status: todo
  Given a template whose dest opts into `renderReferencedFiles`
  And a body including a path another item in the same pass renders
  When che renders the profile
  Then the included file is rendered first
  And the including file resolves it
  And a clean checkout, carrying none of the generated files, renders as well as a working copy

Scenario: the order comes from the templates, not from where a block sits in che.yml
  Status: todo
  Given two items whose spec order contradicts their include dependency
  When che renders them
  Then the dependency decides the order
  And moving either block in `che.yml` changes nothing about the result

Scenario: an include of a file this pass does not render is left to the existing rules
  Status: todo
  Given an `@`-include naming a path no item in the pass produces
  When che renders
  Then no ordering edge is created for it
  And the file is expected on disk, failing or warning exactly as
    [missing sources](render-templates-missing-sources.md) already specifies

Scenario: a repo with no cross-render includes renders exactly as before
  Status: todo
  Given a profile whose templates include nothing another item renders
  When che renders it
  Then the items render in the order the spec lists them
  And no output differs from before ordering existed

## Cycles

Scenario: two files that include each other fail instead of picking a winner
  Status: todo
  Given two templates whose dests each include the other's dest
  When che renders them
  Then the render fails naming the files in the cycle
  And che exits non-zero
  And neither dest is written from a guessed order

## Dry run

Scenario: a dry run predicts the order a real run will take
  Status: todo
  Given a profile whose renders carry include dependencies
  When che runs with `--dry-run`
  Then it reports the same order the real render would use
  And a dest that a real run would resolve is not reported as failing

<!-- [<] 🤖🤖 -->
