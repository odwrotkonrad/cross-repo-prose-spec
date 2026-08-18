# Feature: Che as the configuration tool

<!--[>] 🤖🤖 -->

## As a sandbox operator

Builds images from profiles. Does not configure anything by hand.

### The build is reproducible from a profile (todo)

I want che applying the image's configuration from a profile, with nothing
applied by a hand-run command,
so that the build is readable as source.

### The configuration image is rendered, not assembled (todo)

I want che rendering the configuration image's contents from a profile on a host
holding the sources,
so that there is no build script to drift.

### One profile set serves both layers (todo)

I want the installs layer and the configuration layer running the same profiles,
each applying only the ops belonging to it,
so that a profile is authored once.

### The same sources yield the same image (todo)

I want a rebuild from unchanged sources producing identical contents,
so that a rebuild is never a variable.

<!--[<] 🤖🤖 -->
