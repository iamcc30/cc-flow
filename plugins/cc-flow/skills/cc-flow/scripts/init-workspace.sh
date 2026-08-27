#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 /path/to/coordinator-repository" >&2
  exit 2
}

[ "$#" -eq 1 ] || usage

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
template="$skill_dir/assets/workspace-template.yaml"
target=$1

[ -s "$template" ] || {
  echo "Error: workspace template not found: $template" >&2
  exit 1
}

[ -d "$target" ] || {
  echo "Error: coordinator repository does not exist: $target" >&2
  exit 1
}

target=$(CDPATH= cd -- "$target" && pwd)
[ -d "$target/.ai" ] || {
  echo "Error: coordinator is not initialized with CC Flow: $target" >&2
  echo "Run init-project.sh first." >&2
  exit 1
}

destination="$target/.ai/workspace.yaml"
[ ! -e "$destination" ] || {
  echo "Error: workspace configuration already exists: $destination" >&2
  exit 1
}

cp "$template" "$destination"

echo "Created workspace draft: $destination"
echo "Next: inspect the repositories, replace every placeholder, and validate each configured path."
