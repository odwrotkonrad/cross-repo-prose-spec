# Milestone 2: Overview

<!--[>] 🤖🤖 -->

- an in-cluster otel collector receives metrics, traces and logs from session pods and forwards them
  to the endpoints it is given
- sandboxes get an async notification channel: review requests, observations, permission requests,
  configuration notices
- configuration changes reach running sessions without recreating their pods
- session-stats reports per-session cpu, memory and disk over a given window, session-stats-watch
  refreshes the same report, both need the retention the collector provides

<!--[<] 🤖🤖 -->
