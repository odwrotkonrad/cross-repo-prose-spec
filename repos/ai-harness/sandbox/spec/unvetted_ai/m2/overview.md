# Milestone 2: Overview

<!--[>] 🤖🤖 -->

- an in-cluster otel collector receives metrics, traces and logs from session pods and forwards
  them to configured endpoints
- sandboxes get an async notification channel: review requests, observations, permission requests,
  configuration notices
- configuration changes reach running sessions without recreating pods
- session-stats reports per-session cpu, memory and disk over a window, session-stats-watch
  refreshes the same report, both need the collector's retention

<!--[<] 🤖🤖 -->
