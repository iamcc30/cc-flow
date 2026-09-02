# 实施计划

## 适用配置

- delivery_level: `{{DELIVERY_LEVEL}}`
- architecture_style: `{{ARCHITECTURE_STYLE}}`
- 本任务额外门槛：`{{PROFILE_SPECIFIC_GATES_OR_NONE}}`
- 避免过度设计：`{{HOW_THE_SOLUTION_STAYS_PROPORTIONATE}}`

## 目标、场景与成功标准

`{{RESTATED_GOAL_USER_SCENARIO_SUCCESS_CRITERIA_AND_NON_GOALS}}`

## 需求与方案区分

- 用户目标：`{{USER_GOAL}}`
- 用户提出的方案：`{{USER_PROPOSED_SOLUTION_OR_NONE}}`
- 方案属性：`{{candidate / mandatory_constraint / none}}`
- 判断依据：`{{WHY_AND_SUPPORTING_EVIDENCE}}`

## 现状调查与根因

`{{CURRENT_IMPLEMENTATION_EVIDENCE_AND_ROOT_CAUSE_OR_NA}}`

## 推荐方案

`{{PROPOSED_SOLUTION_AND_KEY_DESIGN_CHOICES}}`

## 备选方案与取舍

| 方案 | 优点 | 缺点 | 结论 |
|---|---|---|---|
| `{{OPTION}}` | `{{PROS}}` | `{{CONS}}` | `{{CHOSEN_OR_REJECTED}}` |

## 修改范围

| 文件/模块 | 修改内容 | 原因 |
|---|---|---|
| `{{PATH_OR_MODULE}}` | `{{CHANGE}}` | `{{WHY}}` |

## 执行策略

- 模式：`{{single / coordinated / parallel}}`
- 判断依据：`{{WHY_THIS_MODE_IS_PROPORTIONATE}}`

仅在 `coordinated` 或 `parallel` 时保留并填写下表；`single` 模式写明无需拆分即可。

| 工作流 | 独立交付结果 | 前置依赖 | 写入边界 | 执行者 |
|---|---|---|---|---|
| `{{WORKSTREAM_ID_OR_NA}}` | `{{DELIVERABLE}}` | `{{DEPENDENCY_OR_NONE}}` | `{{OWNED_PATHS_OR_READ_ONLY}}` | `{{MAIN_OR_SUBAGENT_ROLE}}` |

- 主 Agent 集成点：`{{INTEGRATION_AND_HANDOFF_OR_NA}}`

## 影响分析

- 业务规则：`{{IMPACT_OR_NONE_WITH_REASON}}`
- API/事件：`{{IMPACT_OR_NONE_WITH_REASON}}`
- 数据/迁移：`{{IMPACT_OR_NONE_WITH_REASON}}`
- 兼容性：`{{IMPACT_OR_NONE_WITH_REASON}}`
- 安全/隐私：`{{IMPACT_OR_NONE_WITH_REASON}}`
- 性能/容量：`{{IMPACT_OR_NONE_WITH_REASON}}`
- 部署/运维/可观测性：`{{IMPACT_OR_NONE_WITH_REASON}}`

## 实施步骤

1. `{{STEP_WITH_EXPECTED_RESULT}}`
2. `{{STEP_WITH_EXPECTED_RESULT}}`
3. `{{STEP_WITH_EXPECTED_RESULT}}`

## 测试计划

- 目标测试：`{{TEST_AND_EXPECTED_RESULT}}`
- 单元测试：`{{TEST_AND_EXPECTED_RESULT}}`
- 集成/E2E：`{{TEST_AND_EXPECTED_RESULT_OR_NA}}`
- 静态检查/构建：`{{COMMANDS}}`
- 手工/专项检查：`{{CHECK_OR_NA}}`

## 风险与缓解

| 风险 | 可能性 | 影响 | 缓解/监控 |
|---|---|---|---|
| `{{RISK}}` | `{{H/M/L}}` | `{{H/M/L}}` | `{{MITIGATION}}` |

## 回滚方案

`{{EXACT_ROLLBACK_STEPS_AND_DATA_CONSIDERATIONS}}`

## 未知项与假设

- `{{QUESTION_OR_ASSUMPTION}}`
