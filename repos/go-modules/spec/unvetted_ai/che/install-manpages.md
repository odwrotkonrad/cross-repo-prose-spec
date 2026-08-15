# Feature: Install Manpages

<!-- [>] 🤖🤖 -->

The `manpages:` key in packages.yml declares the manual pages a package ships,
as `<name>.<section>` entries: on a package entry (every method) or on an
installer item (overrides the entry for its method, `[]` overrides to none:
one method may provide pages while another does not). Package managers install
pages themselves; the base non-manager methods get their own support:
`binariesRemoteArchive` items declare `extractManpages:` archive member paths
(token-expanded like `extractBinaries`) placed into a man dir on the man
search path, `buildFromSource` relies on `make install` under its prefix.
Declared pages feed verification (browsable via `man`) and a duplicate check.

Scenario: a package declares its manpages once for all its methods
  Status: todo
  Given an entry with `manpages: [<name>.<section>, ...]` at entry level
  When manpage verification or checks run for any of its methods
  Then those pages apply to each method's install

Scenario: an installer item overrides the entry's manpages for its method
  Status: todo
  Given an entry-level `manpages:` and an item-level `manpages:` on one method
  When manpage verification or checks run
  Then the item's list applies to its method (an empty list means the method ships no pages)
  And the entry's list applies to the remaining methods

Scenario: a malformed manpage name fails at parse time
  Status: todo
  Given a `manpages:` entry without a `<name>.<section>` shape
  When the packages file loads
  Then loading fails naming the offending value and the expected shape

Scenario: binariesRemoteArchive installs manpages from the archive
  Status: todo
  Given a `binariesRemoteArchive` item with `extractManpages:` member paths (`{version}`/`{arch}` tokens allowed)
  When the archive installs
  Then each member links from the extracted opt tree into `<manDir>/man<section>/<name>.<section>`
  And the section derives from the member's filename suffix
  And a declared member missing from the archive fails the install

Scenario: the manpage install destination resolves against the man search path
  Status: todo
  Given manpage destination candidates (default `~/.local/share/man`), configurable like the binaries and completions destinations
  When the destination resolves
  Then the first candidate on the man search path wins
  And no candidate on it warns and falls back to the first

Scenario: a source build's manpages land under its prefix
  Status: todo
  Given a `buildFromSource` entry declaring `manpages:`
  When the build installs
  Then `make install` places the pages under `<prefix>/share/man`
  And a prefix `share/man` absent from the man search path warns

Scenario: an install e2e proves declared manpages are browsable
  Status: todo
  Given an entry or item declaring `manpages:`
  When the install e2e runs one of its methods
  Then `man -w <section> <name>` resolves each declared page
  And the manpage checks run in addition to the method's verify strategy

Scenario: a check warns on missing declared manpages
  Status: todo
  Given installed packages declaring `manpages:`
  When `che packages check-manpages` runs
  Then a declared page resolving nowhere on the man search path warns, naming the page

Scenario: a check warns on duplicate manpages
  Status: todo
  Given a declared page name and section resolving in more than one man search path dir
  When `che packages check-manpages` runs
  Then a warning lists every location of the page

<!-- [<] 🤖🤖 -->
