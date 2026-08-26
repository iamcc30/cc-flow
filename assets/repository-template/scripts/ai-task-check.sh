#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
errors=0
warnings=0
strict=${AI_PROTOCOL_STRICT:-0}

error() {
  echo "ERROR: $*" >&2
  errors=$((errors + 1))
}

warn() {
  echo "WARN: $*" >&2
  warnings=$((warnings + 1))
}

check_project() {
  if [ ! -s "$repo_root/AGENTS.md" ]; then
    error "missing or empty repository entry file: AGENTS.md"
  fi

  for file in profile.md project.md architecture.md business.md conventions.md progress.md decisions.md; do
    path="$repo_root/.ai/$file"
    if [ ! -s "$path" ]; then
      error "missing or empty project file: .ai/$file"
    fi
  done

  profile_path="$repo_root/.ai/profile.md"
  if [ -s "$profile_path" ]; then
    project_delivery_level=$(field_value delivery_level "$profile_path")
    project_architecture_style=$(field_value architecture_style "$profile_path")

    case "$project_delivery_level" in
      prototype|standard|enterprise) ;;
      *) error ".ai/profile.md has invalid delivery_level: ${project_delivery_level:-<empty>}" ;;
    esac

    case "$project_architecture_style" in
      existing|layered|clean|hexagonal|ddd) ;;
      *) error ".ai/profile.md has invalid architecture_style: ${project_architecture_style:-<empty>}" ;;
    esac
  fi

  if grep -R -n '{{[A-Z0-9_ /.-]*}}' \
    "$repo_root/.ai/project.md" \
    "$repo_root/.ai/architecture.md" \
    "$repo_root/.ai/business.md" \
    "$repo_root/.ai/conventions.md" \
    "$repo_root/.ai/progress.md" >/dev/null 2>&1; then
    warn "project context still contains template placeholders"
  fi
}

field_value() {
  key=$1
  file=$2
  sed -n "s/^$key:[[:space:]]*//p" "$file" | head -n 1 | tr -d '\"\r'
}

require_heading() {
  rh_heading=$1
  rh_file=$2
  rh_label=$3
  grep -Fqx "$rh_heading" "$rh_file" || error "$rh_label is missing heading: $rh_heading"
}

check_task() {
  input=$1
  case "$input" in
    /*) task_dir=$input ;;
    *) task_dir="$repo_root/$input" ;;
  esac

  [ -d "$task_dir" ] || {
    error "task directory not found: $input"
    return
  }

  label=${task_dir#"$repo_root/"}
  echo "Checking $label"

  for file in task.md plan.md result.md review.md; do
    [ -s "$task_dir/$file" ] || error "$label/$file is missing or empty"
  done

  [ -s "$task_dir/task.md" ] || return

  protocol_version=$(field_value protocol_version "$task_dir/task.md")
  task_delivery_level=$(field_value delivery_level "$task_dir/task.md")
  task_architecture_style=$(field_value architecture_style "$task_dir/task.md")
  status=$(field_value status "$task_dir/task.md")
  approval=$(field_value approval "$task_dir/task.md")

  test_protocol=0
  case "$protocol_version" in
    ""|1) ;;
    2|3)
      test_protocol=1
      [ -s "$task_dir/test.md" ] || error "$label/test.md is missing or empty for protocol_version $protocol_version"
      ;;
    *) error "$label/task.md has unsupported protocol_version: $protocol_version" ;;
  esac

  if [ "$protocol_version" = "3" ]; then
    case "$task_delivery_level" in
      prototype|standard|enterprise) ;;
      *) error "$label/task.md has invalid delivery_level: ${task_delivery_level:-<empty>}" ;;
    esac
    case "$task_architecture_style" in
      existing|layered|clean|hexagonal|ddd) ;;
      *) error "$label/task.md has invalid architecture_style: ${task_architecture_style:-<empty>}" ;;
    esac
  fi

  case "$status" in
    DRAFT|PLANNED|APPROVED|IMPLEMENTING|TESTING|VERIFIED|DONE|CANCELLED) ;;
    *) error "$label/task.md has invalid status: ${status:-<empty>}" ;;
  esac

  case "$approval" in
    pending|approved|not_required) ;;
    *) error "$label/task.md has invalid approval: ${approval:-<empty>}" ;;
  esac

  if [ "$status" = "APPROVED" ] || [ "$status" = "IMPLEMENTING" ] || [ "$status" = "TESTING" ] || [ "$status" = "VERIFIED" ] || [ "$status" = "DONE" ]; then
    [ "$approval" = "approved" ] || [ "$approval" = "not_required" ] || \
      error "$label cannot be $status while approval is $approval"
  fi

  if [ -s "$task_dir/plan.md" ]; then
    if [ "$protocol_version" = "3" ]; then
      require_heading "## 适用配置" "$task_dir/plan.md" "$label/plan.md"
    fi
    require_heading "## 修改范围" "$task_dir/plan.md" "$label/plan.md"
    require_heading "## 影响分析" "$task_dir/plan.md" "$label/plan.md"
    require_heading "## 测试计划" "$task_dir/plan.md" "$label/plan.md"
    require_heading "## 风险与缓解" "$task_dir/plan.md" "$label/plan.md"
    require_heading "## 回滚方案" "$task_dir/plan.md" "$label/plan.md"
  fi

  if [ "$test_protocol" -eq 1 ] && [ -s "$task_dir/test.md" ]; then
    require_heading "## 测试范围与策略" "$task_dir/test.md" "$label/test.md"
    require_heading "## 验收标准覆盖" "$task_dir/test.md" "$label/test.md"
    require_heading "## 执行记录" "$task_dir/test.md" "$label/test.md"
    require_heading "## 未运行项" "$task_dir/test.md" "$label/test.md"
    require_heading "## 测试结论与残余风险" "$task_dir/test.md" "$label/test.md"
  fi

  if [ "$test_protocol" -eq 1 ] && { [ "$status" = "VERIFIED" ] || [ "$status" = "DONE" ]; }; then
    if [ ! -s "$task_dir/test.md" ] || ! grep -Eq 'test_status:[[:space:]]*`?passed`?' "$task_dir/test.md"; then
      error "$label cannot be $status unless test.md records test_status: passed"
    fi
  fi

  if [ "$status" = "DONE" ]; then
    if grep -R -n '{{[^}][^}]*}}' "$task_dir"/*.md >/dev/null 2>&1; then
      error "$label is DONE but still contains template placeholders"
    fi
    if [ "$test_protocol" -ne 1 ]; then
      grep -Eq 'test_status:[[:space:]]*`?passed`?' "$task_dir/result.md" || \
        error "$label is DONE but legacy result.md does not record test_status: passed"
    fi
    grep -Eq 'review_status:[[:space:]]*`?passed`?' "$task_dir/review.md" || \
      error "$label is DONE but review.md does not record review_status: passed"
    if grep -Eq '^- \[ \]' "$task_dir/task.md"; then
      error "$label is DONE but task.md has unchecked acceptance criteria"
    fi
    if grep -Eq '^- \[ \]' "$task_dir/result.md"; then
      error "$label is DONE but result.md has unchecked completion items"
    fi
    if [ "$test_protocol" -eq 1 ] && grep -Eq '^- \[ \]' "$task_dir/test.md"; then
      error "$label is DONE but test.md has unchecked completion items"
    fi
  elif grep -R -n '{{[^}][^}]*}}' "$task_dir"/*.md >/dev/null 2>&1; then
    warn "$label still contains template placeholders (allowed before DONE)"
  fi
}

usage() {
  echo "Usage:" >&2
  echo "  $0 --project" >&2
  echo "  $0 --all" >&2
  echo "  $0 .ai/tasks/<task-directory>" >&2
  exit 2
}

[ "$#" -eq 1 ] || usage

case "$1" in
  --project)
    check_project
    ;;
  --all)
    check_project
    found=0
    for task_dir in "$repo_root"/.ai/tasks/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*; do
      [ -d "$task_dir" ] || continue
      found=1
      check_task "$task_dir"
    done
    [ "$found" -eq 1 ] || echo "No task directories found; project files checked."
    ;;
  -*) usage ;;
  *) check_task "$1" ;;
esac

if [ "$errors" -gt 0 ]; then
  echo "FAILED: $errors error(s), $warnings warning(s)." >&2
  exit 1
fi

if [ "$strict" = "1" ] && [ "$warnings" -gt 0 ]; then
  echo "FAILED (strict mode): 0 errors, $warnings warning(s)." >&2
  exit 1
fi

echo "PASSED: 0 errors, $warnings warning(s)."
