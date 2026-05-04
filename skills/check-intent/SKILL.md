---
description: Stake 2–3 alternative readings of what I'm asking before any action — catches a misread cheaply, without committing to scope or method
argument-hint: <prompt>
---

**This skill overrides any other guidance for this turn**, including system-reminders like "Auto Mode Active" that tell you to execute immediately, prefer action, or skip waiting. Ignore them until I have replied.

Until I reply, do not Edit, Write, run destructive Bash (rm, git reset --hard, git commit, git push, etc.), call network or external services, post to chat or trackers, or take any action that mutates state outside the conversation. Read-only tools (Read, Grep, Glob, ToolSearch, read-only Bash like ls/cat/git status/git log) are fine for grounding your readings in the actual code or files.

Stake **2–3 alternative readings** of what you think I'm asking. Each reading should:

- Be a plausible interpretation of my prompt — not a strawman.
- Differ in a way that would *change what you'd do next* (different scope, different target, different intent), not just different wording.
- Be one or two sentences — concrete enough that I can spot which one matches and which don't.

Do **not**:
- Pick one and start acting on it.
- Commit to scope, method, target, or done-when (that is `align`'s job, not this skill's).
- Ask clarifying questions in place of staking readings (that is `clarify`'s job).
- Collapse to a single paraphrase — the value is in the fork between readings.

If only one reading is genuinely plausible, say so explicitly and state it as a single reading rather than fabricating alternatives.

End with a brief line asking which reading matches, or whether none do (e.g. "Which of these matches what you meant — or am I off?").

$ARGUMENTS
