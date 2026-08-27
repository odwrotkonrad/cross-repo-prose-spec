# Feature: deep file-path completion (dirs for cd, files and dirs for file commands)

<!-- [>] 🤖🤖 -->

Scenario Outline: a query with no path separator searches a single path segment (implemented)
  Given the typed query "<query>"
  When I press TAB
  Then the query fuzzy-matches one path segment: the match's own segment for its group
  And a match on a shallower segment never carries into a deeper group
  And the listed matches are exactly "<matches>"

  Examples:
    | query | matches                              |
    | rt    | root                                 |
    | data  | root/datasource, root/dir/datasource |
    | src   | root/datasource, root/dir/datasource |
    | dir   | root/dir                             |

Scenario Outline: a query with path separators splits per segment, matching in order, gaps allowed (implemented)
  Given the typed query "<query>"
  When I press TAB
  Then the query splits on / into per-segment queries
  And each fuzzy-matches a path segment, in typed order, segments skippable between them
  And the last matches the match's own segment for its group
  And the listed matches are exactly "<matches>"

  Examples:
    | query  | matches                              |
    | da     | root/datasource, root/dir/datasource |
    | source | root/datasource, root/dir/datasource |
    | rot/da | root/datasource, root/dir/datasource |
    | r/src  | root/datasource, root/dir/datasource |
    | d/da   | root/dir/datasource                  |

<!-- [<] 🤖🤖 -->
