#!/bin/bash
# Claude Code Status Line - Context bar, model, and git info

input=$(cat)

eval "$(echo "$input" | jq -r '
  "MODEL=" + (.model.display_name // "Claude" | @sh),
  "INPUT_TOKENS=" + ((.context_window.total_input_tokens // 0) | tostring),
  "OUTPUT_TOKENS=" + ((.context_window.total_output_tokens // 0) | tostring),
  "CONTEXT_SIZE=" + ((.context_window.context_window_size // 200000) | tostring),
  "COST=" + ((.cost.total_cost_usd // 0) | tostring),
  "LINES_ADDED=" + ((.cost.total_lines_added // 0) | tostring),
  "LINES_REMOVED=" + ((.cost.total_lines_removed // 0) | tostring),
  "API_TIME_MS=" + ((.cost.total_api_duration_ms // 0) | tostring),
  "FOLDER=" + (.workspace.current_dir // "" | split("/") | last | @sh)
')"

TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))
PERCENT=$((CONTEXT_SIZE > 0 ? TOTAL_TOKENS * 100 / CONTEXT_SIZE : 0))
[ "$PERCENT" -gt 100 ] && PERCENT=100

USED_K=$((TOTAL_TOKENS / 1000))
TOTAL_K=$((CONTEXT_SIZE / 1000))

COST_FMT=$(printf "$%.2f" "$COST")
API_TIME_SEC=$((API_TIME_MS / 1000))
API_TIME_DEC=$(((API_TIME_MS % 1000) / 100))

GIT_INFO=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  [ -n "$BRANCH" ] && GIT_INFO=" | $BRANCH"
else
  GIT_INFO=" | no repo"
fi

echo "$FOLDER/ | $MODEL | ${USED_K}k/${TOTAL_K}k (${PERCENT}%) | $COST_FMT - ${API_TIME_SEC}.${API_TIME_DEC}s | +${LINES_ADDED} -${LINES_REMOVED}$GIT_INFO"
