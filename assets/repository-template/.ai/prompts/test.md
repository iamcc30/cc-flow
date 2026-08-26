# Test 阶段提示模板

```text
你现在处于 TEST 阶段。请阅读 AGENTS.md、.ai/conventions.md，以及 {{TASK_PATH}} 下的 task.md、plan.md 和 result.md。

测试是独立质量门槛：
1. 开始时确认 status 为 TESTING；
2. 根据风险和 plan.md 制定实际测试范围，覆盖验收标准、回归面和失败路径；
3. 运行适用的格式检查、静态检查、类型检查、单元测试、集成/E2E、构建以及安全/迁移/性能/兼容性专项检查；
4. 把每条实际命令、环境、结果和证据写入 {{TASK_PATH}}/test.md；
5. 对未运行项写明原因、替代证据和残余风险；
6. 测试失败且需要改代码时，将 status 退回 IMPLEMENTING；修复后重新执行受影响测试及必要回归；
7. 只有必要测试全部通过且 test_status 为 passed，才能将 status 更新为 VERIFIED 并进入 REVIEW。

不得把未执行、被跳过或仅预计通过的测试标记为 passed。
```
