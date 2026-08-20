# Feature: A rendered value decides whether it overwrites the existing one

<!-- [>] 🤖🤖 -->

Scenario: an unpiped shell value overwrites the existing key (tested)
  Given a dest `.env` holding `REF=old`
  And a template line `REF={{ shell "printf new" }}` with `writeType: mergeUpsert`
  When I invoke `che render-templates`
  Then `.env` holds `REF=new`

Scenario: keepIfExisting keeps the existing key (tested)
  Given a dest `.env` holding `REF=old`
  And a template line `REF={{ shell "printf new" | keepIfExisting }}` with `writeType: mergeUpsert`
  When I invoke `che render-templates`
  Then `.env` holds `REF=old`

Scenario: an unpiped secret value overwrites the existing key (implemented)
  Given a dest `.env` holding `TOKEN=old`
  And a template line `TOKEN={{ secret "op://v/i/f" }}` resolving to `new`
  When I invoke `che render-templates`
  Then `.env` holds `TOKEN=new`

Scenario: keepIfExisting keeps a secret's existing key (implemented)
  Given a dest `.env` holding `TOKEN=old`
  And a template line `TOKEN={{ secret "op://v/i/f" | keepIfExisting }}` resolving to `new`
  When I invoke `che render-templates`
  Then `.env` holds `TOKEN=old`

Scenario: alwaysUpdate overwrites a literal value (tested)
  Given a dest `.env` holding `MODE=mine`
  And a template line `MODE={{ "default" | alwaysUpdate }}` with `writeType: mergeUpsert`
  When I invoke `che render-templates`
  Then `.env` holds `MODE=default`

Scenario: an unpiped literal keeps the existing key (tested)
  Given a dest `.env` holding `MODE=mine`
  And a template line `MODE=default` with `writeType: mergeUpsert`
  When I invoke `che render-templates`
  Then `.env` holds `MODE=mine`

Scenario: a key absent from the dest is written whatever the action (tested)
  Given a dest `.env` without `REF`
  And a template line `REF={{ shell "printf new" | keepIfExisting }}`
  When I invoke `che render-templates`
  Then `.env` holds `REF=new`

Scenario: a key the user added stays (tested)
  Given a dest `.env` holding `MINE=1` and the template not naming `MINE`
  When I invoke `che render-templates`
  Then `.env` still holds `MINE=1`

Scenario: the action leaves no trace in the dest (tested)
  Given a template line `REF={{ shell "printf new" | alwaysUpdate }}`
  When I invoke `che render-templates`
  Then the written line is exactly `REF=new`

Scenario: the pipe is a no-op under another writeType (tested)
  Given a template line `REF={{ shell "printf new" | keepIfExisting }}` with `writeType: overwrite`
  When I invoke `che render-templates`
  Then the dest holds `REF=new`

<!-- [<] 🤖🤖 -->
