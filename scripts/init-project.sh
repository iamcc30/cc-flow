#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 [--force] /path/to/repository" >&2
  exit 2
}

force=0
if [ "${1:-}" = "--force" ]; then
  force=1
  shift
fi

[ "$#" -eq 1 ] || usage

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
template_dir="$skill_dir/assets/repository-template"
target=$1

[ -d "$template_dir" ] || {
  echo "Error: bundled repository template not found: $template_dir" >&2
  exit 1
}

[ -d "$target" ] || {
  echo "Error: target repository does not exist: $target" >&2
  exit 1
}

target=$(CDPATH= cd -- "$target" && pwd)
file_list=$(CDPATH= cd -- "$template_dir" && find . -type f -print | LC_ALL=C sort)

if [ "$force" -eq 0 ]; then
  conflicts=""
  for relative_path in $file_list; do
    clean_path=${relative_path#./}
    if [ -e "$target/$clean_path" ]; then
      conflicts="$conflicts
$clean_path"
    fi
  done

  if [ -n "$conflicts" ]; then
    echo "Error: installation would overwrite existing files:" >&2
    echo "$conflicts" >&2
    echo "No files were copied. Merge them manually or use --force only after explicit approval." >&2
    exit 1
  fi
fi

for relative_path in $file_list; do
  clean_path=${relative_path#./}
  destination="$target/$clean_path"
  mkdir -p "$(dirname -- "$destination")"
  cp "$template_dir/$clean_path" "$destination"
done

chmod +x "$target/.ai/scripts/ai-task-start.sh" \
  "$target/.ai/scripts/ai-task-check.sh" \
  "$target/.ai/scripts/ai-doc-sync.sh"

echo "Installed CC Flow into: $target"
echo "Next: review .ai/profile.md, derive project context, resolve remaining placeholders, and run ./.ai/scripts/ai-task-check.sh --project."
