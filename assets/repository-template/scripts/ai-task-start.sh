#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 <short-slug> \"<task title>\" [owner]" >&2
  exit 2
}

[ "$#" -ge 2 ] && [ "$#" -le 3 ] || usage

slug=$1
title=$2
owner=${3:-unassigned}

case "$slug" in
  *[!a-z0-9-]*|'')
    echo "Error: slug must contain only lowercase letters, digits, and hyphens." >&2
    exit 2
    ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
template_dir="$repo_root/.ai/templates/task"
today=$(date +%Y-%m-%d)
task_id="$today-$slug"
task_dir="$repo_root/.ai/tasks/$task_id"

[ -d "$template_dir" ] || {
  echo "Error: task template not found: $template_dir" >&2
  exit 1
}

[ ! -e "$task_dir" ] || {
  echo "Error: task already exists: $task_dir" >&2
  exit 1
}

mkdir -p "$task_dir"
cp "$template_dir"/*.md "$task_dir/"

escape_sed() {
  printf '%s' "$1" | sed 's/[&|\\]/\\&/g'
}

safe_id=$(escape_sed "$task_id")
safe_title=$(escape_sed "$title")
safe_owner=$(escape_sed "$owner")
safe_date=$(escape_sed "$today")

for file in "$task_dir"/*.md; do
  tmp="$file.tmp"
  sed \
    -e "s|{{TASK_ID}}|$safe_id|g" \
    -e "s|{{TASK_TITLE}}|$safe_title|g" \
    -e "s|{{OWNER}}|$safe_owner|g" \
    -e "s|{{YYYY-MM-DD}}|$safe_date|g" \
    "$file" > "$tmp"
  mv "$tmp" "$file"
done

echo "Created task: .ai/tasks/$task_id"
echo "Next: complete task.md, then use .ai/prompts/plan.md to prepare plan.md."
