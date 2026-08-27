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
parent_task=${CC_FLOW_PARENT_TASK:-N/A}
repository_role=${CC_FLOW_REPOSITORY_ROLE:-repository}

case "$slug" in
  *[!a-z0-9-]*|'')
    echo "Error: slug must contain only lowercase letters, digits, and hyphens." >&2
    exit 2
    ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/../.." && pwd)
template_dir="$repo_root/.ai/templates/task"
profile_file="$repo_root/.ai/profile.md"
today=$(date +%Y-%m-%d)
task_id="$today-$slug"
task_dir="$repo_root/.ai/tasks/$task_id"

[ -d "$template_dir" ] || {
  echo "Error: task template not found: $template_dir" >&2
  exit 1
}

[ -s "$profile_file" ] || {
  echo "Error: project profile not found: $profile_file" >&2
  exit 1
}

delivery_level=$(sed -n 's/^delivery_level:[[:space:]]*//p' "$profile_file" | head -n 1 | tr -d '\"\r')
architecture_style=$(sed -n 's/^architecture_style:[[:space:]]*//p' "$profile_file" | head -n 1 | tr -d '\"\r')

case "$delivery_level" in
  prototype|standard|enterprise) ;;
  *) echo "Error: invalid delivery_level in .ai/profile.md: ${delivery_level:-<empty>}" >&2; exit 1 ;;
esac

case "$architecture_style" in
  existing|layered|clean|hexagonal|ddd) ;;
  *) echo "Error: invalid architecture_style in .ai/profile.md: ${architecture_style:-<empty>}" >&2; exit 1 ;;
esac

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
safe_delivery_level=$(escape_sed "$delivery_level")
safe_architecture_style=$(escape_sed "$architecture_style")
safe_parent_task=$(escape_sed "$parent_task")
safe_repository_role=$(escape_sed "$repository_role")

for file in "$task_dir"/*.md; do
  tmp="$file.tmp"
  sed \
    -e "s|{{TASK_ID}}|$safe_id|g" \
    -e "s|{{TASK_TITLE}}|$safe_title|g" \
    -e "s|{{OWNER}}|$safe_owner|g" \
    -e "s|{{YYYY-MM-DD}}|$safe_date|g" \
    -e "s|{{DELIVERY_LEVEL}}|$safe_delivery_level|g" \
    -e "s|{{ARCHITECTURE_STYLE}}|$safe_architecture_style|g" \
    -e "s|{{PARENT_TASK_OR_NA}}|$safe_parent_task|g" \
    -e "s|{{REPOSITORY_ROLE}}|$safe_repository_role|g" \
    "$file" > "$tmp"
  mv "$tmp" "$file"
done

echo "Created task: .ai/tasks/$task_id"
echo "Next: complete task.md, then use .ai/prompts/plan.md to prepare plan.md."
