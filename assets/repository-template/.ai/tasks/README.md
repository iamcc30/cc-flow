# 任务记录

每个标准或高风险任务使用独立目录，目录名格式为：

```text
YYYY-MM-DD-short-slug
```

使用脚本创建，不要直接复制后忘记替换任务 ID：

```bash
./.ai/scripts/ai-task-start.sh short-slug "任务标题"
```

脚本会把 `.ai/profile.md` 当前的 `delivery_level` 和 `architecture_style` 写入 `task.md` 和 `plan.md`，作为任务配置快照。后续项目配置变化不会悄悄改变已有任务的完成标准。

任务状态：

```text
DRAFT → PLANNED → APPROVED → IMPLEMENTING → TESTING → VERIFIED → DONE
```

- `DRAFT`：任务信息仍在补充。
- `PLANNED`：调查和计划完成，尚未授权实现。
- `APPROVED`：计划已批准，或按协议标记为无需单独批准。
- `IMPLEMENTING`：正在修改。
- `TESTING`：实现完成，正在执行独立测试并记录 `test.md`。
- `VERIFIED`：必要测试已通过，等待评审/文档收尾。
- `DONE`：满足 `.ai/conventions.md` 的完成定义。

取消的任务保留记录并使用 `CANCELLED`，同时写明原因。被其他任务取代时，互相添加链接。
