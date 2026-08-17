# Spec

- k8s nodes run rootless

<!--[>] 🤖🤖 -->
Feature: Rootless cluster nodes

Scenario: breaking out of a node container gains no root on the host
  Status: todo
  Given a running cluster
  When a node container's host-side owner is inspected
  Then it is an unprivileged user, not root
<!--[<] 🤖🤖 -->
