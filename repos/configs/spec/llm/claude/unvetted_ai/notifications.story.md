# Feature: claude session notifications

<!-- [>] 🤖🤖 -->

## As a session user

Runs claude in one tmux pane among many, works elsewhere while it thinks.

### A finished or waiting session reaches you in another pane (implemented)

I want claude's `preferredNotifChannel` set to `terminal_bell` so finishing a
task or pausing for input or permission rings the bell through the pane tty,
so that attention is pulled without watching the pane.

### The waiting window is visible in the status bar (implemented)

I want tmux monitoring bells with `bell-action any` and `visual-bell off`, the
bell's window highlighted via `window-status-bell-style` and cleared on view,
so that the right window is found without cycling through them.

### The waiting pane is pinpointed among many (implemented)

I want Stop and Notification hooks setting `@claude_attention` so the pane
border shows a claude badge via `pane-border-format`, cleared by the
UserPromptSubmit hook,
so that a window holding several claudes still names the one that stopped.

### A user away from the terminal still gets told (implemented)

I want tmux forwarding pane bells to the attached client and the terminal
turning a received bell into a macOS notification,
so that the desk can be left without losing the session.

## As a repo owner

Owns the zsh config every program runs under, keeps it out of the way.

### The bell path stays intact (implemented)

I want interactive zsh leaving BEL emission unsuppressed,
so that claude and any long-running command reach tmux and the terminal
unaltered.

<!-- [<] 🤖🤖 -->
