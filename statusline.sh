#!/bin/bash
# Claude Code Status Line - Context bar, model, and git info

# Read JSON from stdin
input=$(cat)

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
API_TIME_MS=$(echo "$input" | jq -r '.cost.total_api_duration_ms // 0')
FOLDER=$(echo "$input" | jq -r '.workspace.current_dir // ""' | xargs basename 2>/dev/null || echo "~")

# Calculate context usage percentage
TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))
if [ "$CONTEXT_SIZE" -gt 0 ]; then
  PERCENT=$((TOTAL_TOKENS * 100 / CONTEXT_SIZE))
else
  PERCENT=0
fi

# Clamp to 100%
[ "$PERCENT" -gt 100 ] && PERCENT=100

# Build progress bar (8 chars)
BAR_SIZE=8
FILLED=$((PERCENT * BAR_SIZE / 100))
EMPTY=$((BAR_SIZE - FILLED))

BAR=""
for ((i = 0; i < FILLED; i++)); do BAR+="█"; done
for ((i = 0; i < EMPTY; i++)); do BAR+="░"; done

# Get git info (branch + added/removed lines)
GIT_INFO=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    # Get added/removed lines from git diff
    DIFF_STAT=$(git diff --numstat 2>/dev/null | awk '{add+=$1; del+=$2} END {printf "+%d,-%d", add+0, del+0}')
    GIT_INFO=" | $BRANCH "#| ($DIFF_STAT)"
  fi
else
  GIT_INFO=" | no repo"
fi

# Output status line
# Format cost
COST_FMT=$(printf "$%.2f" "$COST")

# Format API time (convert ms to seconds)
API_TIME_SEC=$(echo "scale=1; $API_TIME_MS / 1000" | bc 2>/dev/null || echo "0")

# Format lines changed
LINES_FMT="+${LINES_ADDED} -${LINES_REMOVED}"

echo "$FOLDER/ | $MODEL | $BAR ${PERCENT}% | $COST_FMT | ${API_TIME_SEC}s | $LINES_FMT$GIT_INFO"
