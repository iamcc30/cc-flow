# Implement 阶段提示模板

```text
你现在处于 IMPLEMENT 阶段。请读取 AGENTS.md、.ai/conventions.md、{{TASK_PATH}}/task.md 和已批准的 plan.md。

仅在 approval 为 approved 或符合规范的 not_required 时实施。严格按批准范围工作：
1. 开始时将 status 更新为 IMPLEMENTING；
2. 进行最小、完整、可维护的修改，不触碰无关改动；
3. 若范围、风险或方案发生实质变化，先更新 plan.md，必要时重新请求批准；
4. 可以运行用于实现反馈的目标检查，但不要替代独立 TEST 阶段；
5. 把变更摘要、实际修改和计划偏差写入 result.md；
6. 实现完成后将 status 更新为 TESTING，停止实现并进入 TEST 阶段；
7. 不得在 IMPLEMENT 阶段把任务标记为 VERIFIED 或 DONE。

不得伪造实现结果，也不得把开发过程中的局部检查冒充完整测试结论。
```
