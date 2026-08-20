# Feature: git checkout branch completion in recency order

<!-- [>] 🤖🤖 -->

Scenario: branch completion lists the most recently committed-to branches first (implemented)
  Given an interactive shell in a git repo with local and remote-tracking branches
  When I complete a branch argument (`git checkout <TAB>`, `git switch <TAB>`, `git branch -d <TAB>`, `git branch -u <TAB>`, `git push origin <TAB>`, `git log <TAB>`)
  Then every group sorts by committerdate, newest first
  And the order matches `git for-each-ref --sort=-committerdate refs/heads` (refs/remotes for remote groups)
  And HEAD, FETCH_HEAD, ORIG_HEAD, MERGE_HEAD top the local group

<!-- [<] 🤖🤖 -->
