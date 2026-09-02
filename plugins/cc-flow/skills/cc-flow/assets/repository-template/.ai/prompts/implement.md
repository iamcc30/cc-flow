# Implement 阶段提示模板

```text
你现在处于 IMPLEMENT 阶段。请读取 AGENTS.md、.ai/profile.md、.ai/conventions.md、{{TASK_PATH}}/task.md 和已批准的 plan.md。

仅在 approval 为 approved 或符合规范的 not_required 时实施。严格按批准范围工作：
1. 开始时将 status 更新为 IMPLEMENTING；
2. 进行最小、完整、可维护的修改，不触碰无关改动；
3. 若范围、风险或方案发生实质变化，先更新 plan.md，必要时重新请求批准；
4. 遵守任务快照中的交付级别和架构风格；不得借架构标签扩大重构范围；
5. 遵循 plan.md 的复用与依赖结论，不重复实现已有的工具、组件、服务或基础设施；语义或边界不匹配时不要强行复用；
6. 需要新增第三方依赖时，仅使用计划中已评估且与当前技术栈兼容的成熟库，并按项目包管理方式更新清单与锁文件；
7. 按 plan.md 的执行模式工作。`parallel` 仅在 Subagent 可用、工作流独立且写入边界不重叠时使用；给每个 Subagent 明确交付结果、依赖、允许写入范围和返回摘要，主 Agent 等待、检查并集成全部结果；
8. 发现共享文件冲突、新依赖或契约变化时停止并行，改为 `coordinated`，必要时更新计划和审批；
9. 可以运行用于实现反馈的目标检查，但不要替代独立 TEST 阶段；
10. 把变更摘要、实际修改、协作结果、配置符合性和计划偏差写入 result.md；
11. 实现完成后将 status 更新为 TESTING，停止实现并进入 TEST 阶段；
12. 不得在 IMPLEMENT 阶段把任务标记为 VERIFIED 或 DONE。

不得伪造实现结果，也不得把开发过程中的局部检查冒充完整测试结论。
```
