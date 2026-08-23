# Feature: Notification channel

<!--[>] 🤖🤖 -->

## As an AI agent

Runs inside a session. Sends messages out, holds no permission beyond the
sandbox identity.

### Reaching the user costs no merge request (todo)

I want to post straight to the notification channel,
so that talking to the user needs no MR.

### Posting never stalls the work (todo)

I want to keep working while a posted message goes unanswered,
so that the channel is async and the session never blocks on a human.

### Review requests, observations and notices all fit one channel (todo)

I want to post a review request naming the session and what to review, an
observation worth a look, or a notice of a configuration change useful to
others,
so that one outward path carries everything worth telling the user.

### Asking for a permission is possible without holding it (todo)

I want to request an action the sandbox identity cannot perform, still unable
to perform it myself,
so that blocked work is visible, not silently dropped.

## As a sandbox operator

Owns the sandbox boundary. Reads what sessions post, never drives a session
through the channel.

### The channel cannot widen the sandbox (todo)

I want nothing done on a session's behalf when a message asks for an action
beyond the sandbox identity,
so that posting grants no permission.

### The channel is outward only (todo)

I want messages flowing from sessions to the user, no route back into a
session,
so that it is a report path, never a control path.

<!--[<] 🤖🤖 -->
