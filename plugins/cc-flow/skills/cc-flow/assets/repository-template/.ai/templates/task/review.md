# 评审记录

- review_status: `{{pending / passed / changes_required}}`
- reviewer: `{{NAME_OR_AI_REVIEWER}}`
- reviewed_at: `{{YYYY-MM-DD}}`
- reviewed_diff: `{{COMMIT_RANGE_OR_WORKTREE}}`

## 评审范围

`{{FILES_BEHAVIORS_AND_TESTS_REVIEWED}}`

## 发现

| 严重度 | 位置 | 问题与影响 | 建议 | 状态 |
|---|---|---|---|---|
| `{{BLOCKER/HIGH/MEDIUM/LOW}}` | `{{PATH:LINE}}` | `{{FINDING}}` | `{{RECOMMENDATION}}` | `{{open/resolved/accepted}}` |

若没有发现问题，请写明：`未发现阻断性问题`，并保留下面的残余风险说明。

## 验收标准复核

- [ ] `{{CRITERION}}` — `{{EVIDENCE}}`

## 残余风险

- `{{RISK_OR_NONE}}`

## 结论

`{{APPROVE_OR_REQUEST_CHANGES_WITH_REASON}}`
