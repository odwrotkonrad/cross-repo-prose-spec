# Feature: Session interface

<!--[>] 🤖🤖 -->

Scenario: attaching with no session creates one, so the first run needs no setup step (implemented)
  Given no session exists
  When session-attach runs
  Then a session is created
  And the shell attaches to it

Scenario: attaching with one session attaches to it (implemented)
  Given exactly one running session
  When session-attach runs
  Then the shell attaches to it without asking

Scenario: attaching with several sessions offers a picker (implemented)
  Given more than one running session
  When session-attach runs
  Then the sessions are offered to pick from
  And the picked one is attached

Scenario: the picker can reach stopped sessions, so past work stays inspectable (implemented)
  Given a stopped session with data on disk
  When session-attach is asked to show stopped sessions
  Then the stopped session is offered
  And picking it makes its data readable

Scenario: creating always makes a new session (tested)
  Given a running session
  When session-create runs
  Then a second session is created
  And the first is untouched

Scenario: listing shows running sessions, and stopped ones on request (tested)
  Given a running session and a stopped session
  When session-ls runs
  Then the running session is listed
  And the stopped session is listed when stopped sessions are requested

Scenario: stopping keeps the data (tested)
  Given a running session
  When session-stop runs
  Then its pod is shut down
  And its data remains

Scenario: a new session gets a mnemonic name (tested)
  Given no name is supplied
  When a session is created
  Then it is named a random mnemonic
  And the name is pronounceable, not a timestamp

Scenario: two sessions created together get different names (tested)
  Given one session
  When another is created without a name
  Then its name differs from the first

Scenario: a session can be renamed (implemented)
  Given a session
  When session-rename gives it a new name
  Then it is listed under the new name
  And session-attach reaches it by that name

Scenario: renaming keeps the session's data (tested)
  Given a running session with work on disk
  When it is renamed
  Then its data is intact

Scenario: renaming does not restart the session (todo)
  Given a running session
  When it is renamed
  Then its pod was not restarted

Scenario: a rename cannot collide with an existing session (tested)
  Given two sessions
  When one is renamed to the other's name
  Then the rename is refused
  And both keep their names

Scenario: session verbs are prefixed, so the interface is legible in one listing (implemented)
  Given the make targets
  When they are listed
  Then every session verb is prefixed session-
  And image builds and cluster bootstrap are not session verbs

<!--[<] 🤖🤖 -->
