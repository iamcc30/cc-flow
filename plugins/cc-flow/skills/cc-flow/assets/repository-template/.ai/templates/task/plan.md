# 实施计划

## 适用配置

delivery_level: `{{DELIVERY_LEVEL}}`；architecture_style: `{{ARCHITECTURE_STYLE}}`。仅补充本任务额外要求。

## 开发基线

{{BRANCH_HEAD_TARGET_SHA_FETCH_AND_SYNC_DECISION}}

## 目标、场景与成功标准

见 [task.md](task.md)，不重复描述。

## 需求与方案区分

用户原始方案及约束见 task.md；仅记录新的判断或变更。

## 推荐方案

{{MINIMAL_CHANGE_AND_EVIDENCE}}
说明具体证据，以及任何额外复杂度所解决的已确认要求；假设标明验证方式。

## 复用与依赖评估

{{REUSE_PATH_AND_REASON}}
注明已有入口、参考实现、复用内容和新增理由；替换时列出调用方及测试/夹具/配置/导出影响，说明迁移清理或必要并存的原因、负责人和退出条件。
仅在新增依赖时补充来源、兼容、安全、许可和维护成本；无需逐项列出所有未采用选项。

## 修改范围

{{FILES_AND_CHANGES}}

## 执行策略

默认 single。仅在确有收益时记录子工作流、依赖、写入范围和集成点。

## 影响分析

{{AFFECTED_BEHAVIOR_INTERFACES_DATA_OR_NONE}}

## 测试计划

{{ACCEPTANCE_IDS_COMMANDS_AND_EXPECTED_RESULTS}}

## 风险与缓解

{{MATERIAL_RISKS_OR_NONE}}

## 回滚方案

{{ROLLBACK_OR_NOT_APPLICABLE_REASON}}
