#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

if [ -f "$skill_root/.agents/plugins/marketplace.json" ]; then
  plugin_root="$skill_root/plugins/cc-flow"
  plugin_skill_root="$plugin_root/skills/cc-flow"

  test -s "$plugin_root/.codex-plugin/plugin.json"
  grep -Eq '"name"[[:space:]]*:[[:space:]]*"cc-flow"' "$skill_root/.agents/plugins/marketplace.json"
  grep -Eq '"path"[[:space:]]*:[[:space:]]*"\./plugins/cc-flow"' "$skill_root/.agents/plugins/marketplace.json"
  grep -Eq '"version"[[:space:]]*:[[:space:]]*"[0-9]+\.[0-9]+\.[0-9]+"' "$plugin_root/.codex-plugin/plugin.json"

  for source_path in SKILL.md agents assets references scripts; do
    diff -qr "$skill_root/$source_path" "$plugin_skill_root/$source_path"
  done
fi

test -s "$skill_root/SKILL.md"
test -s "$skill_root/agents/openai.yaml"
test -s "$skill_root/assets/repository-template/.ai/prompts/understand.md"
test -s "$skill_root/assets/repository-template/.ai/prompts/plan.md"
test -s "$skill_root/assets/repository-template/.ai/prompts/test.md"
test -s "$skill_root/assets/repository-template/.ai/templates/task/test.md"
grep -Fqx '## 执行策略' "$skill_root/assets/repository-template/.ai/templates/task/plan.md"
grep -Fqx '## 需求与方案区分' "$skill_root/assets/repository-template/.ai/templates/task/plan.md"
grep -Fqx '## 推荐方案' "$skill_root/assets/repository-template/.ai/templates/task/plan.md"
grep -Fqx '## 复用与依赖评估' "$skill_root/assets/repository-template/.ai/templates/task/plan.md"
grep -Fqx '## 用户场景' "$skill_root/assets/repository-template/.ai/templates/task/task.md"
grep -Fqx '## 用户提出的方案' "$skill_root/assets/repository-template/.ai/templates/task/task.md"
test -s "$skill_root/assets/repository-template/.ai/profile.md"
test -s "$skill_root/assets/workspace-template.yaml"
grep -Fq 'Do not use for read-only work' "$skill_root/SKILL.md"
grep -Fq 'Prefer reuse before new implementation' "$skill_root/SKILL.md"
grep -Fq 'routine Git integration' "$skill_root/SKILL.md"
grep -Eq 'allow_implicit_invocation:[[:space:]]*true' "$skill_root/agents/openai.yaml"
grep -Fqx '## Applicability' "$skill_root/assets/repository-template/AGENTS.md"
grep -Fqx '## 1. 适用范围' "$skill_root/assets/repository-template/.ai/conventions.md"
grep -Fq '项目已有实现与惯例、标准库/框架能力、已有依赖、成熟第三方库、自定义实现' "$skill_root/assets/repository-template/.ai/conventions.md"
grep -Fq '常规 merge/rebase/cherry-pick' "$skill_root/assets/repository-template/.ai/conventions.md"
grep -Fq 'do not create or update CC Flow task records' "$skill_root/assets/repository-template/CLAUDE.md"
grep -Fq 'do not create or update CC Flow records' "$skill_root/assets/repository-template/.cursor/rules/ai-development-protocol.mdc"
grep -Fq 'do not create or update CC Flow records' "$skill_root/assets/repository-template/.github/copilot-instructions.md"

for shell_file in "$skill_root"/scripts/*.sh "$skill_root"/assets/repository-template/.ai/scripts/*.sh; do
  sh -n "$shell_file"
done

qa_root=$(mktemp -d)
trap 'rm -rf "$qa_root"' 0
mkdir -p "$qa_root/repository"
"$skill_root/scripts/init-project.sh" "$qa_root/repository" >/dev/null
"$skill_root/scripts/init-workspace.sh" "$qa_root/repository" >/dev/null

test -s "$qa_root/repository/.ai/workspace.yaml"
test -s "$qa_root/repository/.ai/prompts/understand.md"
grep -Fqx '## Applicability' "$qa_root/repository/AGENTS.md"
grep -Fqx '## 1. 适用范围' "$qa_root/repository/.ai/conventions.md"
test ! -e "$qa_root/repository/.codex"
test -x "$qa_root/repository/.ai/scripts/ai-task-start.sh"
test -x "$qa_root/repository/.ai/scripts/ai-task-check.sh"
test -x "$qa_root/repository/.ai/scripts/ai-doc-sync.sh"
test ! -e "$qa_root/repository/scripts/ai-task-start.sh"
grep -Fq 'AI_PROTOCOL_STRICT=1 ./.ai/scripts/ai-task-check.sh --all' "$qa_root/repository/.github/workflows/ai-protocol.yml"
grep -Eq '^workspace_version:[[:space:]]*1$' "$qa_root/repository/.ai/workspace.yaml"
if "$skill_root/scripts/init-workspace.sh" "$qa_root/repository" >/dev/null 2>&1; then
  echo "Expected workspace initializer to refuse an existing configuration." >&2
  exit 1
fi

cd "$qa_root/repository"
CC_FLOW_TASK_MODE=full \
CC_FLOW_PARENT_TASK=workspace-parent \
CC_FLOW_REPOSITORY_ROLE=backend \
  ./.ai/scripts/ai-task-start.sh validation "Validate independent test gate" ci >/dev/null
task_dir=$(find .ai/tasks -mindepth 4 -maxdepth 4 -type d | head -n 1)
task_date=$(dirname "$task_dir" | sed 's|^.ai/tasks/||; s|/|-|g')
task_name=$(basename "$task_dir")

printf '%s\n' "$task_date" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
printf '%s\n' "$task_name" | grep -Eq '^[0-9]{6}-validation$'
test -s "$task_dir/test.md"
grep -Fqx '## 执行策略' "$task_dir/plan.md"
grep -Eq '^protocol_version:[[:space:]]*4$' "$task_dir/task.md"
grep -Eq "^id:[[:space:]]*\"$task_date-[0-9]{6}-validation\"$" "$task_dir/task.md"
grep -Eq '^delivery_level:[[:space:]]*"standard"$' "$task_dir/task.md"
grep -Eq '^architecture_style:[[:space:]]*"existing"$' "$task_dir/task.md"
grep -Eq '^parent_task:[[:space:]]*"workspace-parent"$' "$task_dir/task.md"
grep -Eq '^repository_role:[[:space:]]*"backend"$' "$task_dir/task.md"
./.ai/scripts/ai-task-check.sh "$task_dir"

# Full accepts concise sync evidence and old completed checklists, never blanks.
doc_sync_dir="$qa_root/doc-sync"
mkdir -p "$doc_sync_dir"
cp "$task_dir/task.md" "$task_dir/plan.md" "$doc_sync_dir/"
for summary in \
  '无需更新：仅修复内部实现，项目事实和使用方式未变化。' \
  '- [README](../../README.md)：修正测试命令。' \
  '- [x] `.ai/progress.md`：NOT_NEEDED — 当前里程碑未变化'; do
  printf '## 文档同步\n\n%s\n\n## 已知限制与后续事项\n无\n' "$summary" > "$doc_sync_dir/result.md"
  ./.ai/scripts/ai-doc-sync.sh "$doc_sync_dir"
done
for summary in '' '{{UPDATED_DOCS}}' '- [ ] README：待核实'; do
  printf '## 文档同步\n\n%s\n\n## 已知限制与后续事项\n不能充当同步证据\n' "$summary" > "$doc_sync_dir/result.md"
  if ./.ai/scripts/ai-doc-sync.sh "$doc_sync_dir" >/dev/null 2>&1; then
    echo "Expected incomplete document sync evidence to fail." >&2
    exit 1
  fi
done
printf '## 实际修改\n仅有实现摘要\n' > "$doc_sync_dir/result.md"
if ./.ai/scripts/ai-doc-sync.sh "$doc_sync_dir" >/dev/null 2>&1; then
  echo "Expected a missing document sync section to fail." >&2
  exit 1
fi

invalid_v4_dir="$qa_root/invalid-v4-task"
cp -R "$task_dir" "$invalid_v4_dir"
sed 's/^## 用户场景$/## 场景信息/' "$invalid_v4_dir/task.md" > "$invalid_v4_dir/task.md.tmp"
mv "$invalid_v4_dir/task.md.tmp" "$invalid_v4_dir/task.md"
if ./.ai/scripts/ai-task-check.sh "$invalid_v4_dir" >/dev/null 2>&1; then
  echo "Expected protocol v4 validation to reject a missing product-intent heading." >&2
  exit 1
fi

legacy_dated_dir=".ai/tasks/2026-08-25/legacy-validation"
mkdir -p "$(dirname "$legacy_dated_dir")"
cp -R "$task_dir" "$legacy_dated_dir"
sed \
  -e 's/^protocol_version:[[:space:]]*4$/protocol_version: 3/' \
  -e 's/^## 用户目标$/## 目标/' \
  -e 's/^## 用户场景$/## 场景信息/' \
  -e 's/^## 成功标准$/## 验收标准/' \
  -e 's/^## 用户提出的方案$/## 方案输入/' \
  "$legacy_dated_dir/task.md" > "$legacy_dated_dir/task.md.tmp"
mv "$legacy_dated_dir/task.md.tmp" "$legacy_dated_dir/task.md"
sed \
  -e 's/^## 目标、场景与成功标准$/## 目标理解/' \
  -e 's/^## 需求与方案区分$/## 方案背景/' \
  -e 's/^## 推荐方案$/## 方案/' \
  "$legacy_dated_dir/plan.md" > "$legacy_dated_dir/plan.md.tmp"
mv "$legacy_dated_dir/plan.md.tmp" "$legacy_dated_dir/plan.md"
./.ai/scripts/ai-task-check.sh "$legacy_dated_dir"

legacy_task_dir=".ai/tasks/2026-08-26-legacy-validation"
cp -R "$task_dir" "$legacy_task_dir"
./.ai/scripts/ai-task-check.sh "$legacy_task_dir"
legacy_timed_dir=".ai/tasks/2026-08-27/123456-legacy-validation"
mkdir -p "$(dirname "$legacy_timed_dir")"
cp -R "$task_dir" "$legacy_timed_dir"
./.ai/scripts/ai-task-check.sh "$legacy_timed_dir"
./.ai/scripts/ai-task-check.sh --all

# The default creates one record; completion gates must reject missing evidence.
./.ai/scripts/ai-task-start.sh compact-validation "Compact validation" ci >/dev/null
compact_dir=$(find .ai/tasks -name '*-compact-validation' -type d | head -n 1)
test "$(find "$compact_dir" -type f | wc -l | tr -d ' ')" = 1
grep -Eq '^protocol_version: 5$' "$compact_dir/task.md"
./.ai/scripts/ai-task-check.sh "$compact_dir"
./.ai/scripts/ai-doc-sync.sh "$compact_dir"

# Check both modes, including nested paths with spaces, without deleting evidence.
for checked_task in "$task_dir" "$compact_dir"; do
  mkdir "$checked_task/nested evidence"
  printf 'Short supporting note.\n' > "$checked_task/nested evidence/note.md"
  ./.ai/scripts/ai-task-check.sh "$checked_task" >/dev/null
  for misplaced_name in regression.py fixture.json run.log screenshot.png build.zip; do
    misplaced_path="$checked_task/nested evidence/$misplaced_name"
    printf 'fixture\n' > "$misplaced_path"
    if ./.ai/scripts/ai-task-check.sh "$checked_task" > "$qa_root/misplaced.log" 2>&1; then
      echo "Expected misplaced task file to fail: $misplaced_path" >&2
      exit 1
    fi
    grep -Fq 'contains non-Markdown files' "$qa_root/misplaced.log"
    test -f "$misplaced_path"
    rm "$misplaced_path"
  done
  rm "$checked_task/nested evidence/note.md"
  rmdir "$checked_task/nested evidence"
done
# A targeted check does not sweep unrelated historical tasks.
printf 'fixture\n' > "$task_dir/old.log"
./.ai/scripts/ai-task-check.sh "$compact_dir" >/dev/null
rm "$task_dir/old.log"

sed -e 's/status: DRAFT/status: DONE/' -e 's/approval: pending/approval: approved/' \
  -e 's/{{[^}]*}}/fixture evidence/' "$compact_dir/task.md" > "$compact_dir/task.md.tmp"
mv "$compact_dir/task.md.tmp" "$compact_dir/task.md"
if ./.ai/scripts/ai-task-check.sh "$compact_dir" >/dev/null 2>&1; then
  echo "Expected compact completion without test/review evidence to fail." >&2
  exit 1
fi
sed 's/test_status: pending/test_status: passed/' \
  "$compact_dir/task.md" > "$compact_dir/task.md.tmp"
mv "$compact_dir/task.md.tmp" "$compact_dir/task.md"
if ./.ai/scripts/ai-task-check.sh "$compact_dir" >/dev/null 2>&1; then
  echo "Expected compact completion without review evidence to fail." >&2
  exit 1
fi
sed 's/review_status: pending/review_status: passed/' "$compact_dir/task.md" > "$compact_dir/task.md.tmp"
mv "$compact_dir/task.md.tmp" "$compact_dir/task.md"
AI_PROTOCOL_STRICT=1 ./.ai/scripts/ai-task-check.sh "$compact_dir"
sed 's/approval: approved/approval: pending/' "$compact_dir/task.md" > "$compact_dir/task.md.tmp"
mv "$compact_dir/task.md.tmp" "$compact_dir/task.md"
if ./.ai/scripts/ai-task-check.sh --all >/dev/null 2>&1; then
  echo "Expected --all to find and reject an unapproved nested compact task." >&2
  exit 1
fi
if CC_FLOW_TASK_MODE=invalid ./.ai/scripts/ai-task-start.sh invalid-mode invalid >/dev/null 2>&1; then
  echo "Expected invalid task mode to be rejected." >&2
  exit 1
fi

mkdir -p "$qa_root/user-scripts/repository/scripts"
printf '%s\n' '# user-owned script' > "$qa_root/user-scripts/repository/scripts/ai-task-start.sh"
"$skill_root/scripts/init-project.sh" "$qa_root/user-scripts/repository" >/dev/null
grep -Fx '# user-owned script' "$qa_root/user-scripts/repository/scripts/ai-task-start.sh" >/dev/null
test -x "$qa_root/user-scripts/repository/.ai/scripts/ai-task-start.sh"

echo "CC Flow verification passed."
