# Feature: Versioned Brew Formulae

<!-- [>] 🤖🤖 -->

`publish-brew`: each che tag pipeline renders the brew formulae and commits them
to the homebrew tap repo.

## As a release consumer

Installs che with brew on macOS. Reads no pipeline, edits no formula.

### che installs with a plain tap and install (implemented)

I want `Formula/che.rb` (class `Che`) committed to the tap at each released
version,
so that `brew tap odwrotkonrad/tap && brew install che` gets the latest from the
GitHub mirror.

### An exact version installs (implemented)

I want `Formula/che@X.Y.Z.rb` committed alongside it, class named per Homebrew's
rules (`che@0.0.67` -> `CheAT0067`),
so that `brew install che@X.Y.Z` gets exactly that version.

### Past versions never disappear (implemented)

I want each release to add its own versioned formula, none removed or rewritten,
urls pinned to that version's registry path,
so that any past version stays installable.

## As a pipeline maintainer

Owns `publish-brew` and the tap commits. Owns no formula content by hand.

### A tag pipeline re-run is safe (implemented)

I want the commit to fall back between update and create,
so that a formula file already present or missing both succeed with identical
content.

### The render is inspectable without touching the tap (implemented)

I want `RENDER_ONLY=1` to write both formula files to disk and exit before any
tap commit,
so that a dry run costs the tap nothing.

<!-- [<] 🤖🤖 -->
