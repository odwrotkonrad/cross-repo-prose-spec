# Feature: MCP servers for claude and codex

<!-- [>] 🤖🤖 -->

Agents answer from memory where a documentation or search tool would do. Two
MCP servers, tavily (web search) and context7 (library docs), reach both
clients from one profile, keys from 1Password, nothing secret on disk.

## As an agent user

Runs claude and codex on a host loaded by che, keeps credentials in 1Password.

### Both clients see tavily and context7 after a sync (todo)

I want the `mcp` profile registering both servers user-wide in claude
(`claude mcp add-json --scope user`, idempotent) and declaring them in codex's
`config.toml`,
so that every project gets them without per-repo setup.

### Keys are environment, never file content (todo)

I want `TAVILY_API_KEY` and `CONTEXT7_API_KEY` exported by a host-only zshenv
template rendered from `op://ProgrammaticAccess/{tavily,context7}/api_key`,
the client configs referencing the variable names only,
so that no rendered MCP config carries a secret.

### Remote transport where the client allows it (todo)

I want claude on the hosted endpoints (`mcp.tavily.com`, `mcp.context7.com`),
codex on the hosted context7 endpoint and a local tavily process only because
codex cannot expand a key into a URL,
so that a host runs the fewest local server processes.

### A virt host skips the secrets, keeps the wiring (todo)

I want the key export gated to real hosts, the server registrations still
applied on virt,
so that a sandbox gains the servers the moment its secrets arrive.

### Claude may call them unprompted (todo)

I want `mcp__tavily` and `mcp__context7` in claude's permission allow list,
so that a docs lookup never stops for approval.

<!-- [<] 🤖🤖 -->
