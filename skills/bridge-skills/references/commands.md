# bridge CLI — Full Command Reference

All commands run as: `uv run ~/codes/cc-bridge/bridge <subcommand> ...`

All remote paths are relative to `--root-dir` set when the bridge-session was started.

---

## read

Read a remote file. Output is line-numbered (`     1\tline content`).

```bash
bridge read <path>
bridge read <path> --limit 50          # first 50 lines
bridge read <path> --offset 100        # start from line 100 (0-based)
bridge read <path> --offset 100 --limit 50  # lines 100-149
```

**To get raw content without line numbers**, use bash instead:
```bash
bridge bash "cat <path>"
```

---

## write

Upload content to a remote file. Overwrites the entire file.

```bash
bridge write <path> --file local.py         # from a local file
echo "content" | bridge write <path>        # from stdin
bridge bash "cat local.py" | bridge write <path>  # pipe through
```

---

## bash

Run a shell command on the remote host. CWD is the `--root-dir`.

```bash
bridge bash "pwd"
bridge bash "ls -la"
bridge bash "python3 script.py"
bridge bash "rg 'pattern' . -g '*.py' -n"    # search with ripgrep
bridge bash "rg 'pattern' src/ --type py"    # search by file type
bridge bash "find . -name '*.py'"            # find files by pattern
bridge bash "<cmd>" --timeout 60             # custom timeout in seconds (default: 120)
```

Output is capped at **1MB**. Scope `rg`/`find` queries (use `-g`, `--type`, or a subdirectory path) to stay under the limit.

---

## status

Check if the bridge session is alive. Run this before any other command.

```bash
bridge status
```

Returns "Bridge session is active." or exits with an error.

---

## edit

Open a remote file in `$EDITOR` locally. Auto-syncs to remote on each save. Cleans up temp file on exit.

```bash
bridge edit <path>
bridge edit <path> --editor nano       # override $EDITOR
```

**How it works:**
1. Pulls raw file content to a local temp file (preserves file extension for syntax highlighting)
2. Opens `$EDITOR` (default: `vi`) on the temp file
3. Background thread polls for saves (mtime change) and syncs to remote
4. On editor exit: final sync + temp file cleanup

**Limitation:** Editors that fork (e.g. `code` without `--wait`, `subl`) will not work — the editor process exits immediately and the session ends before editing begins.

---

## Session Management

```bash
# Start a session
uv run ~/codes/cc-bridge/bridge-session start -- ssh <host> 'uv run ~/bridge-server --root-dir /path'

# Run in foreground (useful for debugging)
uv run ~/codes/cc-bridge/bridge-session start --foreground -- ssh <host> 'uv run ~/bridge-server --root-dir /path'

# Stop the session
uv run ~/codes/cc-bridge/bridge-session stop

# Check status
uv run ~/codes/cc-bridge/bridge status
```

The session socket lives at `~/.bridge/session.sock` (overridable via `BRIDGE_SOCKET` env var).
