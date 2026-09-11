# 测试记录

- test_status: `{{pending / passed / failed / partial}}`
- tested_diff: `{{COMMIT_RANGE_OR_WORKTREE}}`
- environment: `{{ENVIRONMENT}}`

## 测试范围与策略

{{SCOPE_AND_REGRESSION_BOUNDARY}}

## 验收标准覆盖

引用 task.md 中的验收项编号，不复制需求文本。

{{ACCEPTANCE_IDS_AND_RESULTS}}

## 执行记录

| 命令/检查 | 结果 | 证据摘要或链接 |
|---|---|---|
| {{COMMAND}} | {{RESULT}} | {{EVIDENCE}} |

失败修复后在本处记录重跑结果；完整日志放 CI 或制品，不粘贴到文档。

## 未运行项

{{SKIPPED_REASON_ALTERNATIVE_AND_RISK_OR_NONE}}

## 测试结论与残余风险

{{CONCLUSION_AND_RESIDUAL_RISK}}
