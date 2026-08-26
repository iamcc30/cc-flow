#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

test -s "$skill_root/SKILL.md"
test -s "$skill_root/agents/openai.yaml"
test -s "$skill_root/assets/repository-template/.ai/prompts/test.md"
test -s "$skill_root/assets/repository-template/.ai/templates/task/test.md"

sh -n "$skill_root/scripts/init-project.sh" \
  "$skill_root/assets/repository-template/scripts/ai-task-start.sh" \
  "$skill_root/assets/repository-template/scripts/ai-task-check.sh" \
  "$skill_root/assets/repository-template/scripts/ai-doc-sync.sh"

qa_root=$(mktemp -d)
mkdir -p "$qa_root/repository"
"$skill_root/scripts/init-project.sh" "$qa_root/repository" >/dev/null

cd "$qa_root/repository"
./scripts/ai-task-start.sh validation "Validate independent test gate" ci >/dev/null
task_dir=$(find .ai/tasks -mindepth 1 -maxdepth 1 -type d | head -n 1)

test -s "$task_dir/test.md"
grep -Eq '^protocol_version:[[:space:]]*2$' "$task_dir/task.md"
./scripts/ai-task-check.sh "$task_dir"

echo "CC Flow verification passed."
