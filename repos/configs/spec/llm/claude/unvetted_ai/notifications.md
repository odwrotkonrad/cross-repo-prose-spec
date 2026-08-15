<!--[>] 🤖🤖 -->
Feature: claude session notifications

Scenario: a terminal bell reaches the user in another pane or window when claude finishes or waits
  Status: implemented
  Given claude settings set preferredNotifChannel to terminal_bell
  And claude runs inside a tmux pane
  When claude finishes a task or pauses for input or permission
  Then claude rings the terminal bell through the pane tty

Scenario: the tmux status bar shows which window is waiting
  Status: implemented
  Given tmux monitors bells with bell-action any and visual-bell off
  When a bell rings in any pane
  Then the window carrying that pane highlights via window-status-bell-style in the status bar
  And the highlight clears when the user views the window

Scenario: a pane badge pinpoints the waiting claude among many panes in one window
  Status: implemented
  Given claude hooks on Stop and Notification set the pane option @claude_attention
  When claude finishes a task or pauses for input or permission
  Then the pane border shows a claude badge via pane-border-format
  And the hook on UserPromptSubmit clears the badge when the user submits a prompt

Scenario: the same bell drives a macOS notification for a user away from the terminal
  Status: implemented
  Given the terminal's bell config turns a received bell into a macOS notification
  And tmux forwards pane bells to the attached client
  When claude rings the bell inside a tmux pane
  Then the terminal sounds the bell
  And macOS shows a notification for it

Scenario: zsh leaves the bell path intact for claude and long-running commands
  Status: implemented
  Given zsh config keeps BEL emission unsuppressed in interactive shells
  When any program in the shell writes BEL to the tty
  Then the bell reaches tmux and the terminal unaltered
<!--[<] 🤖🤖 -->
