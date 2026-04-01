---
name: bridge-skills
description: "Guide for using the cc-bridge CLI to access remote filesystems over SSH. This skill should be used when a bridge session is running (or CLAUDE.md references bridge commands), the user asks to read, write, search, or edit files on a remote host, or any task requires operating on remote files that native tools (Read, Write, Grep, Glob) cannot reach."
---

# cc-bridge CLI

To access remote files, use the `bridge` CLI instead of native tools (Read, Write, Grep, Glob). The bridge communicates with a `bridge-server` running on the remote host over a persistent SSH connection managed by `bridge-session`.

## Prerequisites

Always verify the session is alive before use:

```bash
uv run ~/codes/cc-bridge/bridge status
```

If it fails, start a session first:

```bash
uv run ~/codes/cc-bridge/bridge-session start -- ssh <host> 'uv run ~/bridge-server --root-dir /path/to/project'
```

## Command Reference

| Command | Purpose |
|---------|---------|
| `bridge read <path>` | Read a remote file (line-numbered output) |
| `bridge write <path> --file <local>` | Upload a local file to remote |
| `bridge bash "<cmd>"` | Run a shell command on the remote |
| `bridge status` | Check session is alive |
| `bridge edit <path>` | Open remote file in `$EDITOR`, auto-syncs on save |

For full flags and examples, see [references/commands.md](references/commands.md).

## Editing Remote Files (Recommended Pattern)

For any non-trivial edit, use a local temp file as a staging area:

1. **Pull** — `bridge read <path>` to get the current content
2. **Stage locally** — Write it to `/tmp/<filename>` using the Write tool
3. **Edit locally** — Apply changes with the Edit tool (normal incremental diffs)
4. **Push back** — `bridge write <path> --file /tmp/<filename>`

This avoids full rewrites in your head and gives you the full Edit tool experience. Only use `bridge write` with generated content for brand-new files.

## When to Use Bridge vs Native Tools

- **Remote files** → always use bridge commands
- **Local files** → use native Read/Write/Grep/Glob tools
- All paths are **relative to `--root-dir`** set when the session was started

## Key Gotchas

- `bridge read` output includes **line numbers** (`     1\tline content`) — strip them if you need raw content, or use `bridge bash "cat <path>"`
- **Text files only** — content passes through JSON; binary files will be mangled
- `bridge edit` launches `$EDITOR` (default: `vi`) and syncs on each save; editors that fork (e.g. `code` without `--wait`) won't work correctly
- `bridge bash` output is capped at **1MB**; scope `rg`/`find` queries (use `-g`, `--type`, or a subdirectory path) to avoid hitting the limit
