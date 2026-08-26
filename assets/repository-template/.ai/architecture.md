# 系统架构

> 记录稳定的架构事实、边界和依赖方向。详细决策放入 `decisions.md`。

## 架构概览

`{{DESCRIBE_THE_SYSTEM_IN_3_TO_8_SENTENCES}}`

## 系统上下文

```text
{{USER_OR_UPSTREAM}}
        |
        v
{{THIS_SYSTEM}} ---> {{EXTERNAL_SERVICE}}
        |
        v
{{PRIMARY_DATA_STORE}}
```

## 模块与职责

| 模块/目录 | 职责 | 对外接口 | 允许依赖 |
|---|---|---|---|
| `{{MODULE}}` | `{{RESPONSIBILITY}}` | `{{INTERFACE}}` | `{{DEPENDENCIES}}` |

## 依赖规则

1. `{{DEPENDENCY_DIRECTION_RULE}}`
2. `{{BOUNDARY_RULE}}`
3. `{{FORBIDDEN_DEPENDENCY}}`

## 数据架构

- 主要数据实体：`{{ENTITIES}}`
- 数据存储：`{{DATABASE_CACHE_OBJECT_STORAGE}}`
- 一致性策略：`{{TRANSACTION_EVENTUAL_CONSISTENCY_IDEMPOTENCY}}`
- 数据生命周期：`{{RETENTION_ARCHIVE_DELETION}}`
- 敏感数据：`{{CLASSIFICATION_AND_HANDLING_OR_NONE}}`

## 外部系统与接口

| 系统 | 用途 | 协议/鉴权 | 失败策略 | 负责人 |
|---|---|---|---|---|
| `{{SYSTEM}}` | `{{PURPOSE}}` | `{{PROTOCOL_AUTH}}` | `{{TIMEOUT_RETRY_FALLBACK}}` | `{{OWNER}}` |

## 关键质量属性

- 可用性：`{{SLO_OR_EXPECTATION}}`
- 性能：`{{LATENCY_THROUGHPUT}}`
- 扩展性：`{{EXPECTED_SCALE}}`
- 安全性：`{{TRUST_BOUNDARIES_AND_CONTROLS}}`
- 可观测性：`{{LOGS_METRICS_TRACES_ALERTS}}`

## 构建、部署与运行

- 本地启动：`{{COMMAND}}`
- 构建：`{{COMMAND}}`
- 测试：`{{COMMAND}}`
- 部署：`{{PIPELINE_OR_COMMAND}}`
- 回滚：`{{ROLLBACK_METHOD}}`

## 已知技术债与限制

- `{{LIMITATION_OR_DEBT}}`
