# Feature: Linux Sync Jobs in CI

<!-- [>] 🤖🤖 -->

`.gitlab-ci.yml` loads `root/` onto a fresh linux container twice per MR: a dry
run resolving every op without touching the host, and a smoke apply performing
them. Both run on amd64 and arm64. Both extend one hidden base, the dry-run
toggle the only difference.

## As a repo owner

Claims one `root/` tree loads onto any supported host profile, ships that claim
to real hosts.

### An arm64 host is protected from an amd64-only proof (implemented)

I want the dry run and the smoke apply each running on `gke-linux-amd64` and
`gke-linux-arm64`,
so that an arch-conditional profile, install script or package method reddens
the pipeline instead of reaching a host.

### One image tag serves both architectures (implemented)

I want every linux job pulling the `ci-linux:$CI_IMAGES_REF` multi-arch
manifest,
so that no arch-specific image variable exists to drift.

## As a CI maintainer

Owns the pipeline definition, not the profiles it loads.

### Dry run and apply cannot drift apart (implemented)

I want environment, profile, tags and command living once in the shared base,
only the dry-run toggle, stage and apply gating differing,
so that one edit changes both jobs.

### The two platform pairs read alike (implemented)

I want the linux pair and the macos pair each built from one base carrying
script and environment, differing only by dry-run toggle, stage, needs, gating
and, on macos, the profile set,
so that knowing one pair means knowing the other.

### A dry run never touches the secret vault (implemented)

I want templates with `op://` refs skipped, not fetched, in the dry run, as in
the pre-commit validate job,
so that a run that discards its output never pulls a secret.

### A failing apply is diagnosable without a rerun (implemented)

I want che debug output on in both linux jobs,
so that the op sequence lands in the job log the first time.

### A draft MR never performs a real apply (implemented)

I want the apply gated off for drafts and non-MR pipelines, the dry run still
running on both arches,
so that work in progress cannot mutate the container it runs in.

<!-- [<] 🤖🤖 -->
