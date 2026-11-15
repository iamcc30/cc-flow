# 任务记录

Light 不建任务目录；Compact 只有 task.md，Full 使用 task/plan/result/test/review 五份 Markdown 记录。任务按创建年月日和时间存放：

```text
YYYY/MM/DD/
└── HHMMSS-short-slug/
```

使用脚本创建，不要直接复制后忘记替换任务 ID：

```bash
./.ai/scripts/ai-task-start.sh short-slug "任务标题"
```

默认创建 Compact；Full 在同一命令前设置 `CC_FLOW_TASK_MODE=full`。脚本会把 `.ai/profile.md` 当前的配置写入任务，作为完成标准的快照。后续项目配置变化不会悄悄改变已有任务的完成标准。

这里只保存简短 Markdown 记录，不放测试源码、夹具、日志、截图、压缩包或缓存。测试代码回项目既有测试目录，生成物放 .ai 外的既有制品位置；记录结果摘要和链接。不要另建重复总结或靠改后缀、粘贴输出绕过边界。历史任务反映当时基线，不代表当前行为；归档或清理须明确要求，并保留 ID 与引用。

`HHMMSS` 是任务创建时的本地时间，用于让同一天的任务按创建顺序自然排列，不表示优先级或依赖关系。任务 ID 为 `YYYY-MM-DD-HHMMSS-short-slug`，可作为稳定的跨仓库父子任务引用。

旧版 `.ai/tasks/YYYY-MM-DD/short-slug/` 和更早的 `.ai/tasks/YYYY-MM-DD-short-slug/` 任务都可以原样保留，校验脚本同时支持这些结构；升级时不会自动搬迁历史记录。

任务状态：

```text
DRAFT → PLANNED → APPROVED → IMPLEMENTING → TESTING → VERIFIED → DONE
```

- `DRAFT`：任务信息仍在补充。
- `PLANNED`：调查和计划完成，尚未授权实现。
- `APPROVED`：计划已批准，或按协议标记为无需单独批准。
- `IMPLEMENTING`：正在修改。
- `TESTING`：实现完成，正在验证；Compact 记在 task.md，Full 记在 test.md。
- `VERIFIED`：必要测试已通过，等待评审/文档收尾。
- `DONE`：满足 `.ai/conventions.md` 的完成定义。

取消的任务保留记录并使用 `CANCELLED`，同时写明原因。被其他任务取代时，互相添加链接。
