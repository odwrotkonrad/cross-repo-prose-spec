# Feature: Profile validation in CI

<!--[>] 🤖🤖 -->

Scenario: CI dry-runs the profiles instead of building (implemented)
  Given a change to the sandbox or its profiles
  When CI runs
  Then it dry-runs the che profiles
  And it builds neither image

Scenario: a broken profile fails CI before anyone builds (implemented)
  Given a che profile that would fail when applied
  When CI dry-runs the profiles
  Then the run fails naming the profile

Scenario: a dry run changes nothing (implemented)
  Given CI dry-running the che profiles
  When the run completes
  Then no image or cluster state was created or modified

<!--[<] 🤖🤖 -->
