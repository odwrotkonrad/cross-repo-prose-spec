# Feature: Profile validation in CI

<!--[>] 🤖🤖 -->

## As a CI maintainer

Keeps the pipeline cheap and honest. Does not build images.

### CI validates without building (implemented)

I want a change to the sandbox or its profiles dry-running the che profiles,
building neither image,
so that the pipeline takes minutes, not hours.

### A broken profile is caught before anyone builds (implemented)

I want the dry run failing and naming the profile that would fail when applied,
so that the break surfaces at review.

### Validation is free of side effects (implemented)

I want a dry run creating and modifying no image or cluster state,
so that CI can validate as often as it likes.

<!--[<] 🤖🤖 -->
