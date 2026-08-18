# Feature: End-to-end test

<!--[>] 🤖🤖 -->

Scenario: the test bootstraps a cluster from nothing (todo)
  Given a host with no sandbox cluster
  When the e2e test runs
  Then the cluster is created
  And its nodes are ready

Scenario: the test builds every layer (todo)
  Given the e2e test running on the host
  When it reaches the build steps
  Then the base image is built
  And the tools are installed on it
  And the configuration is applied on top

Scenario: the test exercises the session targets (todo)
  Given a bootstrapped cluster
  When the e2e test runs the session targets
  Then a session is created, listed, attached to and stopped
  And each target does what it promises

Scenario: the test covers a configuration update (todo)
  Given a running session created by the e2e test
  When the test updates the configuration
  Then the session is recreated on the rebuilt image
  And a session created after the update sees the change

Scenario: the updated configuration is in the session (todo)
  Given a session recreated on a rebuilt configuration image
  When the test reads the changed file inside the pod
  Then the file holds the new content

Scenario: the session picks the new configuration up, not just the file (todo)
  Given a tool configured by the changed file
  When the test invokes that tool in the session after the update
  Then the tool behaves according to the new configuration

Scenario: work persisted before the update is still there after it (todo)
  Given a session with work in its persisted paths
  When the test updates the configuration
  Then that work is present in the recreated session

Scenario: a broken step fails the test naming what broke (todo)
  Given a step of the setup that no longer works
  When the e2e test runs
  Then it fails
  And it names the step that broke

Scenario: the test leaves the host as it found it (todo)
  Given the e2e test has run to completion
  When the host is inspected
  Then the cluster and sessions it created are gone

<!--[<] 🤖🤖 -->
