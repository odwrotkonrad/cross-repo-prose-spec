# Feature: git-mr-pipeline-status.zsh

<!-- [>] 🤖🤖 -->

## As a developer

Owns the branch under review, wants the CI verdict without a browser.

### The right MR is found with no arguments (implemented)

I want the open MR for the given branch (default current), else the most
recently updated open MR, else `no open MRs` with exit 0,
so that the common case is a bare invocation.

### One report answers how the MR is doing (implemented)

I want ANSI-bold markdown sections `# MR: !iid`, `## Repo`, `## Branch`,
`## Stages`, `## Pipeline Status`, `name:`, `url:`, `pipeline-url:` under the
MR heading, `repo:`, `url:`, `open mr count: 1` under Repo, every url behind a
`url: ` designator, the status line closing the report,
so that one screen replaces the MR page.

### Unpushed, unpulled and unmerged work surfaces before review (implemented)

I want `## Branch` naming the branch then, after a fetch, `origin - local:` as
✅ synced or ⚠️ ahead (N) / remote ahead (N) / diverged / missing branch, plus
`line changes: +adds -dels (~files files)` and `commit count:` against main,
so that nothing is reviewed against a stale remote.

### Forgotten open MRs surface before they go stale (implemented)

I want more than one open MR replacing the count line with a
`### ⚠️ Open MR count: N` subsection listing each MR as `name:`, `url:`,
`update-time:` newest first, the selected branch's MR first and marked
`current: true`,
so that abandoned reviews are seen, not accumulated.

### The command blocks until the verdict (implemented)

I want a 10s poll until the pipeline fails or succeeds, a bold
`## Inprogress Log` opened after `## Branch`, each completed job printed once
to stderr as `done: <emoji> <duration> <name>`, each poll as
`waiting: <running jobs with elapsed>` or `no job running yet`,
so that waiting on CI needs no second terminal.

### An instant snapshot mid-run (implemented)

I want `--no-wait` reporting at once, running jobs shown 🕐 with elapsed since
start,
so that a glance costs no wait.

## As a pipeline maintainer

Reads stage timings and job outcomes, chases the slow and the broken.

### Slow stages stand out by wall time (implemented)

I want stages in pipeline order headed `### <stage> <wall time>`, wall time max
finished_at minus min started_at over the stage's jobs (now when unfinished,
omitted when none ran), each job as `<emoji> <duration> <name>` with `url:`
below and a blank line between, manual jobs marked ` (manual trigger)`,
canceled ones ` (canceled)`,
so that the expensive stage is obvious without arithmetic.

### Job status readable at a glance (implemented)

I want ✅ success, ❌ failed, 🚫 canceled, ⏭️ skipped, ⚙️ manual, 🕐 running,
⏳ otherwise, fixed-width `MMmSSs` durations space-padded up to 1h, `-` for
jobs that never ran,
so that columns align and scanning is one pass.

### Main's own pipeline reported the same way (implemented)

I want `--main` skipping the MR and branch sections, keeping `## Repo`, picking
the latest push-sourced main pipeline, heading `# Main Pipeline` with `url:`
and `sha:`, keeping stages, status and wait polling, printing `none: <reason>`
with exit 0 when main has no pipeline,
so that a merge is verified with the same tool as a review.

### Branch main implies --main (implemented)

I want `--branch=main` or a bare run from main behaving as `--main`, `--main`
with any other `--branch` exiting 2 with `--main excludes --branch`,
so that the flag is never needed twice and never contradicts itself.

## As an operator

Fans the command over many repos, reads exit codes, not prose.

### The pipeline verdict is the exit code (implemented)

I want exit 1 only for a failed or canceled pipeline, exit 0 for success,
still running under `--no-wait`, manual, blocked, no open MRs, and no pipeline
with a `none: <reason>` line naming what was missing,
so that a multi-repo run flags exactly the repos that broke.

<!-- [<] 🤖🤖 -->
