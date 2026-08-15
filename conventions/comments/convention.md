# Commenting Convention

Comments advertise themselves with a label prefix, so a reader decides upfront whether to read on. Prefixes also help prose-in-code postprocessing and programmatic retrieval. Unprefixed comments have no defined purpose.

## Syntax

| Token | Meaning |
| ----- | ------- |
| `[where]` | related reads, sources, references |
| `[why]` | why it exists, purpose, why chosen over else |
| `[what]` | what it is |
| `[>]` `[<]` | section start, end (leader + N extra leaders, N = depth from top) |
| 🤖 🤖🤖 🤖🤖🤖 | AI-generated section |

## AI-Generated Content

AI-generated content is wrapped in a section whose name is one or more 🤖, encoding how much **more** human attention is wanted: 🤖🤖🤖 a lot more, 🤖🤖 some more, 🤖 a little more.

## Sectioning

A section starts with `[>]` and ends with `[<]`, both carry the section name. Nesting repeats the file's comment leader (its first character): top level carries the fewest extra leaders, each deeper level one more, so the extra-leader count equals the section's depth from the top. Leader `#`: top `##[>] x`, nested `###[>] x`. Leader `//`: `///[>] x`, `////[>] x`.

## Example

Commented files in `example/`: `example.go` (leader `//`), `example.zsh` (leader `#`). Inline, block, and section forms, 🤖 marks.
