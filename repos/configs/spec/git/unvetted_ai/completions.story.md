# Feature: git checkout branch completion in recency order

<!-- [>] 🤖🤖 -->

## As a developer

Switches branches from an interactive shell, forgets branch names.

### The branch you just left is the first offer (implemented)

I want every branch completion (`git checkout`, `git switch`, `git branch -d`,
`git branch -u`, `git push origin`, `git log`) sorted by committerdate newest
first in every group, matching `git for-each-ref --sort=-committerdate`, HEAD,
FETCH_HEAD, ORIG_HEAD and MERGE_HEAD topping the local group,
so that the most recent branch is one TAB away.

<!-- [<] 🤖🤖 -->
