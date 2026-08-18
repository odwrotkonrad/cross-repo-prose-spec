# Feature: Profile validation in CI

<!--[>] 🤖🤖 -->

## As a CI maintainer

Keeps the pipeline cheap and honest. Does not build images.

### CI validates without building (todo)

I want a change to the sandbox or its profiles dry-running the che profiles and
building neither image,
so that the pipeline stays minutes, not hours.

### A broken profile is caught before anyone builds (todo)

I want the dry run failing and naming the profile that would fail when applied,
so that the break surfaces at review time.

### Validation is free of side effects (todo)

I want a completed dry run creating and modifying no image or cluster state,
so that CI can validate as often as it likes.

<!--[<] 🤖🤖 -->
