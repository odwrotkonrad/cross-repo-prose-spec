<!--[>] 🤖🤖 -->
Feature: GCP spend alerting

Scenario: overspending surfaces early instead of on the invoice
  Status: todo
  Given a budget on the whole billing account with a $100 amount
  When actual spend crosses half the amount, and again when it reaches the amount
  Then a notification is delivered at each threshold
  And the figure covers every project, so it reads as total GCP exposure

Scenario: a spending trend warns before the money is gone
  Status: todo
  Given the budget carries a forecasted-spend threshold as well as actual ones
  When GCP projects month-end spend to exceed the budget
  Then a notification is delivered while there is still time to act

Scenario: alerts arrive where they will be seen
  Status: todo
  Given notification channels for email and, when a verified number is configured, SMS
  When a threshold is crossed
  Then the alert reaches those channels
  And billing-account administrators still receive the default notification as a backstop

Scenario: the ceiling moves without touching code
  Status: todo
  Given the budget amount and alert destinations are terraform variables
  When the ceiling or a recipient changes
  Then only variable values change, not resource definitions

Scenario: nobody mistakes an alert for a spending cap
  Status: todo
  Given GCP budgets notify but never stop charges
  And billing data lags real usage by hours
  When the critical threshold fires
  Then the documented response is a human action: scale the CI node pools to zero, then destroy them if needed
  And the cluster's own `max_node_count` remains the mechanism that actually bounds spend

<!--[<] 🤖🤖 -->
