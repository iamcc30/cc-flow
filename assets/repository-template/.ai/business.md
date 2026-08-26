# 业务上下文

> 记录实现代码前必须理解的业务语言、规则、状态与异常。规则变化时必须在同一任务中更新本文件。

## 统一术语

| 术语 | 定义 | 不应混用的概念 |
|---|---|---|
| `{{TERM}}` | `{{DEFINITION}}` | `{{DISTINCTION}}` |

## 参与者与权限

| 角色 | 能做什么 | 不能做什么 | 数据范围 |
|---|---|---|---|
| `{{ROLE}}` | `{{ALLOWED}}` | `{{FORBIDDEN}}` | `{{SCOPE}}` |

## 核心业务规则

1. `BR-001`：`{{RULE_WITH_CLEAR_CONDITION_AND_RESULT}}`
2. `BR-002`：`{{RULE_WITH_CLEAR_CONDITION_AND_RESULT}}`
3. `BR-003`：`{{RULE_WITH_CLEAR_CONDITION_AND_RESULT}}`

## 核心流程

### `{{FLOW_NAME}}`

前置条件：

- `{{PRECONDITION}}`

主流程：

1. `{{STEP}}`
2. `{{STEP}}`
3. `{{STEP}}`

异常与补偿：

- `{{FAILURE}}` → `{{EXPECTED_HANDLING}}`

结果与副作用：

- `{{RESULT_EVENT_NOTIFICATION_OR_LEDGER_CHANGE}}`

## 状态机

| 当前状态 | 事件/条件 | 下一状态 | 副作用 | 非法操作处理 |
|---|---|---|---|---|
| `{{STATE}}` | `{{EVENT}}` | `{{NEXT_STATE}}` | `{{SIDE_EFFECT}}` | `{{ERROR_OR_NOOP}}` |

## 边界与不变量

- `{{INVARIANT_THAT_MUST_ALWAYS_HOLD}}`
- `{{BOUNDARY_OR_LIMIT}}`
- 幂等键/去重规则：`{{IDEMPOTENCY_RULE}}`

## 时间、金额与精度

- 时区：`{{TIMEZONE_AND_STORAGE_RULE}}`
- 金额：`{{CURRENCY_MINOR_UNIT_ROUNDING}}`
- 时间窗口：`{{TIMEOUT_EXPIRY_SETTLEMENT_RULE}}`

## 审计与合规

- 必须记录：`{{AUDIT_EVENTS}}`
- 保存周期：`{{RETENTION}}`
- 隐私要求：`{{PRIVACY_RULES_OR_NONE}}`
