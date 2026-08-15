# Feature: Example Greeter

<!-- [>] 🤖🤖 -->

Scenario: a caller sees their own name in the greeting, confirming their input was received
  Status: tested
  When I invoke `greet Ada`
  Then the output reads `hello Ada`

<!-- [<] 🤖🤖 -->
