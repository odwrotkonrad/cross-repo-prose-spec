# Feature: Every Repo Declares Its Artifacts

<!-- [>] 🤖🤖 -->

A repo publishes things other repos consume, and consumes things other repos
publish. Today that is stated in one `.repo/cross-repo-interface.yml` naming
bare strings like `cross-repo/prose/assets/repo-prose`, with no version
anywhere and no way to say which of a repo's own outputs an upstream actually
rebuilds.

An artifact is a versioned addressable thing, defined by five fields: `type`,
`git-uri` (the repo that builds it), `uri` (where it is published), `version`,
and `version-env-var` (the CI variable carrying that version). `uri` and
`git-uri` differ because an image lives in a registry and a module at a module
path, while both come out of a git repo.

Names like `repo-prose`, `doc-templates` and `license` are not artifacts: they
are paths inside one git repository released at one tag, and nothing can
consume one at a version the others are not also at.

Five files carry this, under `.repo/`. One defines the artifacts and the
dependencies between them. Two more, each a template and its rendered output,
carry what the repo produces and consumes at which version. The template names
the environment variable, the rendered file carries the resolved value.

## As a repo owner

Declares what this repo publishes and depends on. Maintains no list of other
repos.

### Say what an artifact is once (todo)

I want `type`, `git-uri` and `version-env-var` written once per artifact in
`artifacts-graph.yml`, everything else naming only its `uri`,
so that a moved registry or renamed variable is one edit, not a sweep.

### Address an artifact by where it lives (todo)

I want the `uri` to be the artifact's identity, with no separate key to invent
or keep in sync,
so that two repos declaring one artifact agree by construction instead of by
reconciliation.

### Publish several artifacts from one repo (todo)

I want each artifact to carry its own `uri` and `version` under a shared
`git-uri`,
so that a repo building four things is ordinary rather than a special case.

### Declare what my artifact is built from (todo)

I want `depends_on:` keyed by my own artifact, listing the upstreams it is
built from,
so that I state a fact I own and can check locally, never an upstream's blast
radius.

### Say outright that nothing rebuilds an artifact (todo)

I want an empty list to mean no upstream rebuilds it, distinct from the
artifact being absent and undeclared,
so that "nothing depends on this" is a decision on the page, not an omission.

### Keep versions out of what I hand-edit (todo)

I want the hand-edited files to carry environment variable references and the
generated files to carry resolved versions,
so that editing structure and recording a version are separate acts on separate
files.

### Render versions with the workspace's own templating (todo)

I want the version templates to use the same syntax every other rendered file
uses,
so that no bespoke substitution step exists to learn or maintain.

## As an agent editing a repo

Reads the declarations before changing anything. Writes the generated halves,
never the hand-edited ones.

### Know which files are mine to write (todo)

I want the hand-edited templates and the generated outputs plainly separated,
so that I never hand-edit a file that the next render overwrites.

### Fail loudly on an undefined artifact (todo)

I want a produced, consumed or `depends_on` entry naming a `uri` absent from
`artifacts-graph.yml` to fail, naming both,
so that a typo is caught at declaration rather than at use.

<!-- [<] 🤖🤖 -->
