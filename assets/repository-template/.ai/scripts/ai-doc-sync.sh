#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 .ai/tasks/<YYYY>/<MM>/<DD>/<HHMMSS-slug>" >&2
  exit 2
}

[ "$#" -eq 1 ] || usage

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/../.." && pwd)

case "$1" in
  /*) task_dir=$1 ;;
  *) task_dir="$repo_root/$1" ;;
esac

[ -d "$task_dir" ] || {
  echo "Error: task directory not found: $1" >&2
  exit 1
}

if grep -Eq '^protocol_version:[[:space:]]*5$' "$task_dir/task.md"; then
  "$script_dir/ai-task-check.sh" "$task_dir"
  echo "Compact mode: update only changed durable facts; no per-document checklist required."
  exit 0
fi

result="$task_dir/result.md"
plan="$task_dir/plan.md"
[ -s "$plan" ] && [ -s "$result" ] || {
  echo "Error: plan.md and result.md are required." >&2
  exit 1
}

# Validate the summary, not the truth of its claims; review checks current facts.
sync_summary=$(awk '
  /^## 文档同步[[:space:]]*$/ { in_sync=1; next }
  /^## / && in_sync { exit }
  in_sync { print }
' "$result")
if ! printf '%s\n' "$sync_summary" | grep -q '[^[:space:]]' ||
   printf '%s\n' "$sync_summary" | grep -Eq '\{\{|^[[:space:]]*[-*] \[ \]'; then
  echo "MISSING: document sync summary in result.md; list changed docs and facts, or explain why no update was needed." >&2
  exit 1
fi

echo "Document sync summary is present. Review changed facts and links against code/configuration/tests."
