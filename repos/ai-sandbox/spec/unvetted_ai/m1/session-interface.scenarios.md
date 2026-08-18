# Feature: Session interface

<!--[>] 🤖🤖 -->

Scenario: attaching with no session creates one, so the first run needs no setup step (todo)
  Given no session exists
  When session-attach runs
  Then a session is created
  And the shell attaches to it

Scenario: attaching with one session attaches to it (todo)
  Given exactly one running session
  When session-attach runs
  Then the shell attaches to that session without asking

Scenario: attaching with several sessions offers a picker (todo)
  Given more than one running session
  When session-attach runs
  Then the sessions are offered to pick from
  And the picked one is attached

Scenario: the picker can reach stopped sessions, so past work stays inspectable (todo)
  Given a stopped session with data on disk
  When session-attach is asked to show stopped sessions
  Then the stopped session is offered
  And picking it makes its data readable

Scenario: creating always makes a new session (todo)
  Given a running session already exists
  When session-create runs
  Then a second session is created
  And the existing one is untouched

Scenario: listing shows running sessions, and stopped ones on request (todo)
  Given a running session and a stopped session
  When session-ls runs
  Then the running session is listed
  And the stopped session is listed when stopped sessions are requested

Scenario: stopping keeps the data (todo)
  Given a running session
  When session-stop runs
  Then its pod is shut down
  And its data remains

Scenario: a new session gets a mnemonic name (todo)
  Given no name is supplied
  When a session is created
  Then it is named a random mnemonic
  And the name is pronounceable rather than a timestamp

Scenario: two sessions created together get different names (todo)
  Given one session already exists
  When another is created without a name
  Then its name differs from the existing one

Scenario: a session can be renamed (todo)
  Given a session
  When session-rename gives it a new name
  Then it is listed under the new name
  And session-attach reaches it by that name

Scenario: renaming keeps the session's data and state (todo)
  Given a running session with work on disk
  When it is renamed
  Then its data is intact
  And it was not restarted

Scenario: a rename cannot collide with an existing session (todo)
  Given two sessions
  When one is renamed to the other's name
  Then the rename is refused
  And both keep the names they had

Scenario: session verbs are prefixed, so the interface is legible in one listing (todo)
  Given the make targets
  When they are listed
  Then every session verb is prefixed session-
  And building either image and bootstrapping the cluster are not session verbs

<!--[<] 🤖🤖 -->
