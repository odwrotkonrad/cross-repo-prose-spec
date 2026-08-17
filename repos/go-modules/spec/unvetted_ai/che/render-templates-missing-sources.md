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

## Missing template file

Scenario: one broken template does not cost the whole render pass
  Status: tested
  Given a profile whose leaves include a source path that does not exist
  And a further leaf whose source is fine
  When che renders the profile
  Then the missing one is reported as a failure naming its path
  And the healthy leaf still renders
  And che exits non-zero

## Missing func source

Scenario: a mistyped path in a template surfaces instead of rendering empty
  Status: tested
  Given a template calling `localFile`, `frontmatter`, `readBody` or `renderMarkdown` on an absent path
  When che renders it
  Then the render fails naming the template and the missing path
  And no dest is written

Scenario: a doc reader fails on its own when handed an absent path
  Status: tested
  Given `readBody` or `frontmatter` called with a path absent under the repo root
  When it runs
  Then it returns an error naming the path

## Missing @-include

Scenario: a broken doc include is caught before the doc ships
  Status: tested
  Given a dest opting into `renderReferencedFiles`
  And the rendered body carrying an `@<path>` line whose file is absent
  When che renders that dest
  Then the render fails naming the include line and the missing path
  And the dest is not written

Scenario: a tilde include is held to the same standard as a repo-relative one
  Status: tested
  Given a dest opting into `renderReferencedFiles`
  And the body carrying an `@~/<path>` line resolving to nothing under the home tree
  When che renders that dest
  Then the render fails naming that include line

Scenario: a tilde include finds the file the rest of che would load
  Status: tested
  Given a body carrying an `@~/<path>` line
  When includes are resolved
  Then the path resolves under the repo tree's `root/_home/` home marker
  And it matches the marker every other che op uses

Scenario: a native @-import still reaches the agent file untouched
  Status: tested
  Given a dest not opting into `renderReferencedFiles`
  And the body carrying an `@<path>` line
  When che renders that dest
  Then the line is written verbatim
  And no source lookup gates the write

Scenario: a typo in a native @-import is visible without breaking the render
  Status: tested
  Given a dest not opting into `renderReferencedFiles`
  And the body carrying an `@<path>` line whose file is absent
  When che renders that dest
  Then a warning names the dest and the unresolved line
  And the dest is still written

Scenario: a resolvable native @-import stays quiet
  Status: tested
  Given a dest not opting into `renderReferencedFiles`
  And every `@<path>` line resolving to a file
  When che renders that dest
  Then no unresolved-include warning is emitted

Scenario: prose that opens with @ is read as prose
  Status: tested
  Given a body line starting with `@` and carrying whitespace
  When includes are resolved
  Then the line is left as content
  And no missing-source error is raised for it

## Caching

Scenario: a broken include cannot be mistaken for work already done
  Status: tested
  Given a dest whose render would fail on a missing `@`-include
  When che computes whether that dest is already settled
  Then it reports the dest as unsettled

<!-- [<] 🤖🤖 -->
