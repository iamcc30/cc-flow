#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

test -s "$skill_root/SKILL.md"
test -s "$skill_root/agents/openai.yaml"
test -s "$skill_root/assets/repository-template/.ai/prompts/understand.md"
test -s "$skill_root/assets/repository-template/.ai/prompts/plan.md"
test -s "$skill_root/assets/repository-template/.ai/prompts/test.md"
test -s "$skill_root/assets/repository-template/.ai/templates/task/test.md"
grep -Fqx '## 执行策略' "$skill_root/assets/repository-template/.ai/templates/task/plan.md"
test -s "$skill_root/assets/repository-template/.ai/profile.md"
test -s "$skill_root/assets/workspace-template.yaml"

sh -n "$skill_root/scripts/init-project.sh" \
  "$skill_root/scripts/init-workspace.sh" \
  "$skill_root/assets/repository-template/.ai/scripts/ai-task-start.sh" \
  "$skill_root/assets/repository-template/.ai/scripts/ai-task-check.sh" \
  "$skill_root/assets/repository-template/.ai/scripts/ai-doc-sync.sh"

qa_root=$(mktemp -d)
mkdir -p "$qa_root/repository"
"$skill_root/scripts/init-project.sh" "$qa_root/repository" >/dev/null
"$skill_root/scripts/init-workspace.sh" "$qa_root/repository" >/dev/null

test -s "$qa_root/repository/.ai/workspace.yaml"
test -s "$qa_root/repository/.ai/prompts/understand.md"
test ! -e "$qa_root/repository/.codex"
test -x "$qa_root/repository/.ai/scripts/ai-task-start.sh"
test -x "$qa_root/repository/.ai/scripts/ai-task-check.sh"
test -x "$qa_root/repository/.ai/scripts/ai-doc-sync.sh"
test ! -e "$qa_root/repository/scripts/ai-task-start.sh"
grep -Eq '^workspace_version:[[:space:]]*1$' "$qa_root/repository/.ai/workspace.yaml"
if "$skill_root/scripts/init-workspace.sh" "$qa_root/repository" >/dev/null 2>&1; then
  echo "Expected workspace initializer to refuse an existing configuration." >&2
  exit 1
fi

cd "$qa_root/repository"
CC_FLOW_PARENT_TASK=workspace-parent \
CC_FLOW_REPOSITORY_ROLE=backend \
  ./.ai/scripts/ai-task-start.sh validation "Validate independent test gate" ci >/dev/null
task_dir=$(find .ai/tasks -mindepth 2 -maxdepth 2 -type d | head -n 1)
task_date=$(basename "$(dirname "$task_dir")")

printf '%s\n' "$task_date" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
test "$(basename "$task_dir")" = "validation"
test -s "$task_dir/test.md"
grep -Fqx '## 执行策略' "$task_dir/plan.md"
grep -Eq '^protocol_version:[[:space:]]*3$' "$task_dir/task.md"
grep -Eq '^delivery_level:[[:space:]]*"standard"$' "$task_dir/task.md"
grep -Eq '^architecture_style:[[:space:]]*"existing"$' "$task_dir/task.md"
grep -Eq '^parent_task:[[:space:]]*"workspace-parent"$' "$task_dir/task.md"
grep -Eq '^repository_role:[[:space:]]*"backend"$' "$task_dir/task.md"
./.ai/scripts/ai-task-check.sh "$task_dir"

legacy_task_dir=".ai/tasks/2026-08-26-legacy-validation"
cp -R "$task_dir" "$legacy_task_dir"
./.ai/scripts/ai-task-check.sh "$legacy_task_dir"
./.ai/scripts/ai-task-check.sh --all

mkdir -p "$qa_root/user-scripts/repository/scripts"
printf '%s\n' '# user-owned script' > "$qa_root/user-scripts/repository/scripts/ai-task-start.sh"
"$skill_root/scripts/init-project.sh" "$qa_root/user-scripts/repository" >/dev/null
grep -Fx '# user-owned script' "$qa_root/user-scripts/repository/scripts/ai-task-start.sh" >/dev/null
test -x "$qa_root/user-scripts/repository/.ai/scripts/ai-task-start.sh"

echo "CC Flow verification passed."
