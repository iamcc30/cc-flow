# 测试记录

- test_status: `{{pending / passed / failed / partial}}`
- tester: `{{NAME_OR_AI_TESTER}}`
- tested_at: `{{YYYY-MM-DD}}`
- tested_diff: `{{COMMIT_RANGE_OR_WORKTREE}}`
- environment: `{{LOCAL_CI_STAGING_AND_RELEVANT_VERSIONS}}`

## 测试范围与策略

`{{WHAT_IS_TESTED_WHY_AND_REGRESSION_BOUNDARY}}`

## 验收标准覆盖

| 验收标准 | 测试方式 | 结果 | 证据 |
|---|---|---|---|
| `{{CRITERION}}` | `{{TEST_CASE_OR_COMMAND}}` | `{{passed / failed}}` | `{{OUTPUT_OR_LINK}}` |

## 执行记录

> 只记录实际执行的命令或检查，不得记录预计结果。

| 类型 | 命令/检查 | 结果 | 证据摘要 |
|---|---|---|---|
| `{{format/lint/type/unit/integration/e2e/build/manual}}` | `{{EXACT_COMMAND_OR_CHECK}}` | `{{passed / failed}}` | `{{OUTPUT_OR_LINK}}` |

## 专项检查

- 安全/隐私：`{{RESULT_OR_NOT_APPLICABLE_WITH_REASON}}`
- 数据迁移：`{{RESULT_OR_NOT_APPLICABLE_WITH_REASON}}`
- 性能/容量：`{{RESULT_OR_NOT_APPLICABLE_WITH_REASON}}`
- 兼容性：`{{RESULT_OR_NOT_APPLICABLE_WITH_REASON}}`
- 可观测性/运维：`{{RESULT_OR_NOT_APPLICABLE_WITH_REASON}}`

## 失败、缺陷与修复回归

| 失败/缺陷 | 处理 | 回归范围 | 最终结果 |
|---|---|---|---|
| `{{FAILURE_OR_NONE}}` | `{{FIX_OR_DECISION}}` | `{{RERUN_SCOPE}}` | `{{RESULT}}` |

## 未运行项

| 检查 | 原因 | 替代证据 | 风险 |
|---|---|---|---|
| `{{CHECK_OR_NONE}}` | `{{REASON}}` | `{{ALTERNATIVE_EVIDENCE}}` | `{{RESIDUAL_RISK}}` |

## 测试结论与残余风险

`{{CONCLUSION_AND_RESIDUAL_RISK_OR_NONE}}`
