#!/usr/bin/env bash
# Claude Code status line — built from statusline JSON input (no external API calls)
# Fields: Context: X% | <Model>: X.XK [| <OtherModel>: X.XK]

STATE_DIR="/tmp/claude-statusline"
mkdir -p "$STATE_DIR"

input=$(cat)

python3 -c '
import sys, json, os

state_dir = sys.argv[1]
raw = sys.argv[2]

try:
    data = json.loads(raw)
except Exception:
    print("--")
    sys.exit(0)

# Context window usage
used_pct = data.get("context_window", {}).get("used_percentage")
context_str = f"Context: {round(used_pct)}%" if used_pct is not None else "Context: --"

# Current model short name
raw_name = data.get("model", {}).get("display_name", "")
def short_model(name):
    name = name.removeprefix("Claude ")
    parts = name.split()
    if parts and len(parts[-1]) == 8 and parts[-1].isdigit():
        parts = parts[:-1]
    return " ".join(parts) if parts else name

current_model = short_model(raw_name)

# Total session tokens
cw = data.get("context_window", {})
total_in  = cw.get("total_input_tokens", 0) or 0
total_out = cw.get("total_output_tokens", 0) or 0
total_tok = total_in + total_out

# Per-model token tracking via state file
session_id = data.get("session_id", "unknown")
state_file = os.path.join(state_dir, f"session-{session_id}.json")

state = {}
if os.path.exists(state_file):
    try:
        with open(state_file) as f:
            state = json.load(f)
    except Exception:
        state = {}

models = state.get("models", {})
last_total = state.get("last_total", 0)

delta = total_tok - last_total
if delta > 0:
    models[current_model] = models.get(current_model, 0) + delta

try:
    with open(state_file, "w") as f:
        json.dump({"models": models, "last_total": total_tok}, f)
except Exception:
    pass

def fmt_tokens(n):
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M"
    if n >= 1000:
        return f"{n/1000:.1f}K"
    return str(n)

# Fixed display order: Opus, Sonnet, Haiku
MODEL_ORDER = ["Opus", "Sonnet", "Haiku"]

def model_sort_key(name):
    for i, prefix in enumerate(MODEL_ORDER):
        if prefix in name:
            return i
    return len(MODEL_ORDER)

# Ensure current model appears even if 0 tokens
if current_model not in models:
    models[current_model] = 0

# Build parts in fixed order
tok_parts = []
for model in sorted(models.keys(), key=model_sort_key):
    count = models[model]
    if count == 0 and model != current_model:
        continue
    if model == current_model:
        tok_parts.append(f"\033[1;4m{model}: {fmt_tokens(count)}\033[0m")
    else:
        tok_parts.append(f"{model}: {fmt_tokens(count)}")

tok_str = " | ".join(tok_parts)

print(f"{context_str} | {tok_str}")
' "$STATE_DIR" "$input"
