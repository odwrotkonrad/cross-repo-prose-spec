# Feature: End-to-end test

<!--[>] 🤖🤖 -->

Scenario: the test bootstraps a cluster from nothing (tested)
  Given a host with no sandbox cluster
  When the e2e test runs
  Then the cluster is created
  And its nodes are Ready

Scenario: the test builds every layer (tested)
  Given the e2e test running on the host
  When it reaches the build steps
  Then the base image is built
  And the tools are installed on it
  And the configuration is applied on top

Scenario: the test exercises the session targets (tested)
  Given a bootstrapped cluster
  When the e2e test runs the session targets
  Then a session is created, listed, renamed and stopped
  And each target does what it promises

Scenario: the test attaches to a session (todo)
  Given a running session created by the e2e test
  When the test runs session-attach against it
  Then it lands in the session's shell

Scenario: the test covers a configuration update (tested)
  Given a running session created by the e2e test
  When the test updates the configuration
  Then the session is recreated on the rebuilt image

Scenario: a session created after the update sees the change (todo)
  Given the e2e test has updated the configuration
  When it creates a new session
  Then that session sees the change

Scenario: the updated configuration is in the session (todo)
  Given a session recreated on a rebuilt configuration image
  When the test reads the changed file inside the pod
  Then the file holds the new content

Scenario: the session picks the new configuration up, not just the file (todo)
  Given a tool configured by the changed file
  When the test invokes that tool in the session after the update
  Then the tool behaves by the new configuration

Scenario: work persisted before the update is still there after it (tested)
  Given a session with work in its persisted paths
  When the test updates the configuration
  Then that work is present in the recreated session

Scenario: a broken step fails the test naming what broke (implemented)
  Given a setup step that no longer works
  When the e2e test runs
  Then it fails
  And it names the step

Scenario: the test leaves no session behind (tested)
  Given the e2e test has run to completion
  When the host is inspected
  Then the sessions it created are gone

Scenario: a passing test takes its cluster with it (todo)
  Given the e2e test created the cluster and passed
  When the host is inspected
  Then the cluster is gone, unasked

<!--[<] 🤖🤖 -->
