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

失败修复后在本处记录重跑结果；完整日志、截图等放 .ai 外的既有制品位置，不粘贴到文档。临时证据注明保存限制，需长期复核的证据使用持久链接；测试源码和夹具放项目既有测试目录。

## 未运行项

{{SKIPPED_REASON_ALTERNATIVE_AND_RISK_OR_NONE}}

## 测试结论与残余风险

{{CONCLUSION_AND_RESIDUAL_RISK}}
