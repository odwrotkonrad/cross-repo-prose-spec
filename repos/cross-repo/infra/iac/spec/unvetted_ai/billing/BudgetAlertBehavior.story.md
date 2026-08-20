# Feature: GCP spend alerting

<!-- [>] 🤖🤖 -->

## As an account owner watching spend

Pays the GCP invoice. Wants warning before it arrives, not after.

### Overspend surfaces before the invoice (implemented)

I want a budget on the whole billing account, $100, notifying at half the
amount and again at the amount,
so that total GCP exposure across every project is visible early.

### A bad trend warns while it can still be stopped (implemented)

I want a forecasted-spend threshold alongside the actual ones,
so that a projected month-end overrun notifies with time left to act.

### Alerts land where they are read (implemented)

I want an email notification channel plus the default billing-administrator
notification,
so that a crossed threshold reaches the address and has a backstop.

### An alert is never mistaken for a cap (todo)

I want the documented response to a critical threshold to be a human action,
scale the CI node pools to zero then destroy them,
so that nobody relies on budgets to stop charges, `max_node_count` being the
mechanism that actually bounds spend.

## As an infra operator

Applies terraform. Changes ceilings and recipients, not resource shapes.

### The ceiling moves without touching code (implemented)

I want the budget amount and alert address as terraform variables,
so that raising the ceiling or changing the recipient is a variable value
change.

<!-- [<] 🤖🤖 -->
