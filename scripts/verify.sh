#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

test -s "$skill_root/SKILL.md"
test -s "$skill_root/agents/openai.yaml"
test -s "$skill_root/assets/repository-template/.ai/prompts/test.md"
test -s "$skill_root/assets/repository-template/.ai/templates/task/test.md"
test -s "$skill_root/assets/repository-template/.ai/profile.md"
test -s "$skill_root/assets/workspace-template.yaml"

sh -n "$skill_root/scripts/init-project.sh" \
  "$skill_root/scripts/init-workspace.sh" \
  "$skill_root/assets/repository-template/scripts/ai-task-start.sh" \
  "$skill_root/assets/repository-template/scripts/ai-task-check.sh" \
  "$skill_root/assets/repository-template/scripts/ai-doc-sync.sh"

qa_root=$(mktemp -d)
mkdir -p "$qa_root/repository"
"$skill_root/scripts/init-project.sh" "$qa_root/repository" >/dev/null
"$skill_root/scripts/init-workspace.sh" "$qa_root/repository" >/dev/null

test -s "$qa_root/repository/.ai/workspace.yaml"
grep -Eq '^workspace_version:[[:space:]]*1$' "$qa_root/repository/.ai/workspace.yaml"
if "$skill_root/scripts/init-workspace.sh" "$qa_root/repository" >/dev/null 2>&1; then
  echo "Expected workspace initializer to refuse an existing configuration." >&2
  exit 1
fi

cd "$qa_root/repository"
CC_FLOW_PARENT_TASK=workspace-parent \
CC_FLOW_REPOSITORY_ROLE=backend \
  ./scripts/ai-task-start.sh validation "Validate independent test gate" ci >/dev/null
task_dir=$(find .ai/tasks -mindepth 1 -maxdepth 1 -type d | head -n 1)

test -s "$task_dir/test.md"
grep -Eq '^protocol_version:[[:space:]]*3$' "$task_dir/task.md"
grep -Eq '^delivery_level:[[:space:]]*"standard"$' "$task_dir/task.md"
grep -Eq '^architecture_style:[[:space:]]*"existing"$' "$task_dir/task.md"
grep -Eq '^parent_task:[[:space:]]*"workspace-parent"$' "$task_dir/task.md"
grep -Eq '^repository_role:[[:space:]]*"backend"$' "$task_dir/task.md"
./scripts/ai-task-check.sh "$task_dir"

echo "CC Flow verification passed."
