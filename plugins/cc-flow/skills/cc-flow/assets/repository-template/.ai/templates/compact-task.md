---
protocol_version: 5
workflow_mode: compact
id: "{{TASK_ID}}"
title: "{{TASK_TITLE}}"
status: DRAFT
approval: pending
owner: "{{OWNER}}"
delivery_level: "{{DELIVERY_LEVEL}}"
architecture_style: "{{ARCHITECTURE_STYLE}}"
parent_task: "{{PARENT_TASK_OR_NA}}"
repository_role: "{{REPOSITORY_ROLE}}"
test_status: pending
review_status: pending
---

## 目标与验收

{{用户目标与可验证的成功标准；仅保留影响实现的场景和约束}}

## 方案与依据

{{基线分支及SHA、目标及获取结果；最小改动、证据、影响范围、验证方式；审批依据}}

## 验证与结果

{{实际变更、测试命令及结果、差异自查结论、未运行项与风险；仅链接发生变化的项目文档}}
