<!--[>] 🤖🤖 -->
Feature: CI job token allowlists

Scenario: a repo's tag pipeline can trigger the downstream it is meant to drive
  Status: implemented
  Given inbound job token scope is enforced on every project by the instance
  And prose is declared in control's job token allowlist
  When a prose tag pipeline runs its trigger job against control
  Then the downstream pipeline is created instead of failing with downstream_pipeline_creation_failed

Scenario: the allowlist is declared next to the project it guards
  Status: implemented
  Given each project may carry a job_token_allowlist of sibling project keys
  When a project needs to accept another project's job token
  Then only that project's tfvars entry changes, not a resource definition

Scenario: granting access never disturbs instance-enforced settings
  Status: implemented
  Given gitlab.com forbids disabling inbound job token scope per project
  When terraform grants one project access to another
  Then it adds a single allowlist entry
  And it never attempts to write the scope-enabled flag

Scenario: access stays one-directional and explicit
  Status: implemented
  Given an allowlist entry names one accessed project and one permitted project
  When prose is permitted to reach control
  Then control gains no reciprocal access to prose
  And no other project is granted access as a side effect

<!--[<] 🤖🤖 -->
