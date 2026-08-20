# Feature: claude session notifications

<!-- [>] 🤖🤖 -->

## As a session user

Runs claude in one tmux pane among many, works elsewhere while it thinks.

### A finished or waiting session reaches you in another pane (implemented)

I want claude's `preferredNotifChannel` set to `terminal_bell`, so a finished
task or a pause for input or permission rings the bell through the pane tty,
so that I notice without watching the pane.

### The waiting window is visible in the status bar (implemented)

I want tmux monitoring bells with `bell-action any` and `visual-bell off`, the
bell's window highlighted via `window-status-bell-style` until viewed,
so that I find the window without cycling through them.

### The waiting pane is pinpointed among many (implemented)

I want Stop and Notification hooks setting `@claude_attention` on the pane, the
UserPromptSubmit hook clearing it,
so that a window with several claudes still marks the one that stopped.

### The waiting pane wears a visible badge (todo)

I want `pane-border-format` showing a claude badge while `@claude_attention` is
set,
so that I spot the pane by eye, not by querying tmux.

### A user away from the terminal still gets told (implemented)

I want tmux forwarding pane bells to the attached client and the terminal
turning a bell into a macOS notification,
so that I can leave the desk without losing the session.

## As a repo owner

Owns the zsh config every program runs under, keeps it out of the way.

### The bell path stays intact (implemented)

I want interactive zsh leaving BEL unsuppressed,
so that claude and any long-running command reach tmux and the terminal
unaltered.

<!-- [<] 🤖🤖 -->
