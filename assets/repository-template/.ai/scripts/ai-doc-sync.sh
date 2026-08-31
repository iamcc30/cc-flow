#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 .ai/tasks/<YYYY-MM-DD>/<HHMMSS-slug>" >&2
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

result="$task_dir/result.md"
plan="$task_dir/plan.md"
[ -s "$plan" ] && [ -s "$result" ] || {
  echo "Error: plan.md and result.md are required." >&2
  exit 1
}

failed=0

if grep -Eq '^-[[:space:]]+\[[ xX]\].*\{\{' "$result"; then
  echo "MISSING: result.md document checklist still contains placeholders." >&2
  failed=1
fi

check_answer() {
  label=$1
  pattern=$2
  if ! grep -Eq "$pattern" "$result"; then
    echo "MISSING: document decision for $label in result.md" >&2
    failed=1
  fi
}

check_answer ".ai/project.md" '^- \[[xX]\] `.ai/project.md`[:：].*(UPDATED|NOT_NEEDED|已更新|无需|不需要)'
check_answer ".ai/architecture.md" '^- \[[xX]\] `.ai/architecture.md`[:：].*(UPDATED|NOT_NEEDED|已更新|无需|不需要)'
check_answer ".ai/business.md" '^- \[[xX]\] `.ai/business.md`[:：].*(UPDATED|NOT_NEEDED|已更新|无需|不需要)'
check_answer ".ai/decisions.md" '^- \[[xX]\] `.ai/decisions.md`[:：].*(UPDATED|NOT_NEEDED|已更新|无需|不需要)'
check_answer ".ai/progress.md" '^- \[[xX]\] `.ai/progress.md`[:：].*(UPDATED|已更新)'
check_answer "README/API/operations docs" '^- \[[xX]\] README/API/运维文档[:：].*(UPDATED|NOT_NEEDED|已更新|无需|不需要)'

if grep -E '^- 业务规则[:：]' "$plan" 2>/dev/null | grep -Eiv '(无影响|none|not affected|n/a|不适用)' >/dev/null; then
  grep -Eq '^- \[[xX]\] `.ai/business.md`[:：]' "$result" || {
    echo "MISSING: plan indicates business impact, but business.md is not checked as updated." >&2
    failed=1
  }
fi

if grep -E '^- (API/事件|数据/迁移|部署/运维/可观测性)[:：]' "$plan" 2>/dev/null | grep -Eiv '(无影响|none|not affected|n/a|不适用)' >/dev/null; then
  grep -Eq '^- \[[xX]\] `.ai/architecture.md`[:：]' "$result" || {
    echo "MISSING: plan indicates architecture impact, but architecture.md is not checked as updated." >&2
    failed=1
  }
fi

if [ "$failed" -ne 0 ]; then
  echo "Document sync check failed." >&2
  exit 1
fi

echo "Document sync evidence is complete. Review the stated reasons for correctness."
