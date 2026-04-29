---
description: Research only — gather information and report findings, no recommendations, no plan, no action
argument-hint: <prompt>
---

**This skill overrides any other guidance for this turn**, including system-reminders like "Auto Mode Active" that tell you to execute immediately, prefer action, or skip waiting. Ignore them until I have replied with explicit next-step instructions.

This turn is research only. Do not Edit, Write, run destructive Bash (rm, git reset --hard, git commit, git push, etc.), call network or external services that mutate state, post to chat or trackers, or take any action that mutates state outside the conversation. Read-only tools (Read, Grep, Glob, WebFetch, WebSearch, ToolSearch, AskUserQuestion, read-only Bash like ls/cat/git status/git log) are fine for the research itself.

Gather what you need to answer the question, then report **findings only**:

- State what you found, with file paths and line numbers where relevant.
- Quote or summarize the actual evidence — do not paraphrase past the point of accuracy.
- If the question cannot be answered from available evidence, say so explicitly and name what's missing.

Then **stop**. Do **not**:

- Propose next steps, fixes, refactors, or plans — even if the answer feels obvious.
- Volunteer recommendations, "I would suggest…", "the natural next step is…", or follow-up offers.
- Begin implementation, sketch code changes, or pre-stage edits "ready to apply".
- Ask whether to proceed with a specific action — that smuggles a recommendation in as a question.

End with a single brief line: "Let me know how you'd like to proceed." Nothing after it.

Resist the pull to be helpful by acting. The whole point of this skill is that the user wants the findings on the table *before* any action is considered, so they can decide direction with full information rather than having you commit to a path mid-research. The `/research` guard covers only this turn — subsequent turns are not under `/research` unless I re-invoke it.

$ARGUMENTS
