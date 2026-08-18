# Feature: Resource statistics

<!--[>] 🤖🤖 -->

## As a sandbox operator

Watches what sessions consume on the cluster. Reads the report, does not enter
a session.

### Every running session is accounted for on its own (todo)

I want each session reported on its own line, one session's figures excluding
the other's,
so that consumption is attributable per session.

### Cpu and memory read three ways (todo)

I want a central value, a peak and a current figure for cpu and memory,
so that a spike is not lost in an average.

### The window is a duration the caller chooses (todo)

I want session-stats to take a window such as 15min or 2h and report its
central value and peak over exactly that span,
so that the timescale of the question is mine to set.

### Current stays comparable across windows (todo)

I want the current figure to be the 1-minute average whatever window is given,
so that "now" means the same thing in every run.

### A brief busy period stays visible (todo)

I want the peak to reflect a short burst inside an otherwise idle window while
the central value stays near idle,
so that averaging never hides the spike that mattered.

### Disk reports only what it means (todo)

I want disk given as space used, with no window, central value or peak,
so that a present size is not dressed up as a time series.

### A young session still reports (todo)

I want a session younger than the window reported over the history it has,
saying the window is not yet filled,
so that a fresh session yields data instead of an error.

### One-shot and watch agree (todo)

I want session-stats to print once and exit, session-stats-watch to refresh the
same report until interrupted, and both to report the same figures for the same
window,
so that the live view and the snapshot are one report in two modes.

<!--[<] 🤖🤖 -->
