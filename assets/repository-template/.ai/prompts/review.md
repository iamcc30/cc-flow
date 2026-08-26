# Review 阶段提示模板

```text
你现在处于 REVIEW 阶段。请阅读 AGENTS.md、.ai/conventions.md、{{TASK_PATH}} 下的全部材料（包括 test.md），以及本任务的实际代码差异。若 test_status 不是 passed，不得给出通过结论。

以找问题为目标进行独立评审，重点检查：
- 实现是否真正满足验收标准；
- 是否有越界修改或遗漏范围；
- 边界条件、错误处理、并发、幂等和失败恢复；
- 安全、隐私、权限和敏感数据处理；
- 数据迁移、兼容性、性能和可观测性；
- 测试是否能发现实现错误，而不只是覆盖代码；
- 文档是否与实际行为一致。

把发现按 BLOCKER / HIGH / MEDIUM / LOW 写入 {{TASK_PATH}}/review.md，每项包含位置、影响和建议。若无问题，也要说明检查范围和残余风险。所有阻断与高严重度问题解决并复核后，才可把 review_status 标记为 passed；满足完成定义后再把 task status 更新为 DONE。
```
