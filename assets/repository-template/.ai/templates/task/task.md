---
id: "{{TASK_ID}}"
title: "{{TASK_TITLE}}"
protocol_version: 4
delivery_level: "{{DELIVERY_LEVEL}}"
architecture_style: "{{ARCHITECTURE_STYLE}}"
status: DRAFT
risk: "{{low / medium / high}}"
owner: "{{OWNER}}"
created: "{{YYYY-MM-DD}}"
parent_task: "{{PARENT_TASK_OR_NA}}"
repository_role: "{{REPOSITORY_ROLE}}"
approval: pending
approver: "{{APPROVER_OR_NA}}"
---

# 任务：{{TASK_TITLE}}

## 背景

`{{WHY_THIS_TASK_IS_NEEDED}}`

## 用户目标

`{{MEASURABLE_OUTCOME}}`

## 用户场景

- 用户/角色：`{{TARGET_USER_OR_ROLE}}`
- 触发场景：`{{WHEN_AND_WHERE_THE_NEED_OCCURS}}`
- 期望改善：`{{USER_VALUE_OR_PROBLEM_REDUCTION}}`

## 非目标

- `{{EXPLICITLY_OUT_OF_SCOPE}}`

## 成功标准

- [ ] `{{ACCEPTANCE_CRITERION_1}}`
- [ ] `{{ACCEPTANCE_CRITERION_2}}`
- [ ] `{{ACCEPTANCE_CRITERION_3}}`

## 用户提出的方案

- 原始方案：`{{USER_PROPOSED_SOLUTION_OR_NONE}}`
- 当前定位：`{{candidate / mandatory_constraint / none}}`
- 判断依据：`{{WHY_IT_IS_OR_IS_NOT_MANDATORY}}`

## 当前状态与复现

`{{CURRENT_BEHAVIOR_AND_REPRODUCTION_STEPS_OR_NA}}`

## 约束

- 技术：`{{TECHNICAL_CONSTRAINTS}}`
- 业务：`{{BUSINESS_CONSTRAINTS}}`
- 兼容：`{{COMPATIBILITY_CONSTRAINTS}}`
- 时间/成本：`{{DELIVERY_CONSTRAINTS}}`

## 已知依赖

- `{{DEPENDENCY_TEAM_SERVICE_OR_TASK}}`

## 参考资料

- `{{LINK_OR_REPOSITORY_PATH}}`

## 授权说明

`approval` 可取：

- `pending`：等待批准，禁止进入实现。
- `approved`：计划已由 `approver` 批准。
- `not_required`：仅限低/中风险且当前任务已明确授权自主执行；在此写明授权依据。

授权依据：`{{APPROVAL_REFERENCE_OR_REASON}}`
