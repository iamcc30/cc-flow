# Structured Task Workflow

Use this procedure after the repository contains the CC Flow layout.

If `.ai/workspace.yaml` applies, use [workspace-workflow.md](workspace-workflow.md) to resolve affected repositories and linked parent/child tasks before following this repository-local procedure.

## Create a task

Use `.ai/prompts/understand.md` as stage guidance. Read the user's original request, required project context, and relevant repository evidence before defining scope. Classify the task using `.ai/conventions.md`; simple tasks may use the lightweight path allowed there.

For a standard or high-risk task, resolve a lowercase hyphenated slug, a clear title, and the owner if known. If no matching active task exists, run from the repository root:

```bash
./.ai/scripts/ai-task-start.sh <slug> "<task title>" [owner]
```

Complete `task.md` from the user's request and repository evidence. The creation script snapshots `.ai/profile.md` into the task. Define observable acceptance criteria without prescribing an unapproved implementation. Mark material unknowns and ask only for decisions that cannot be determined safely; do not invent facts or business rules. Keep status `DRAFT` and approval `pending` until the Plan stage changes them.

## Plan

Read the required project context, `.ai/profile.md`, and the new task. Use `.ai/prompts/plan.md` as stage guidance. Perform read-only investigation and complete `plan.md` with concrete files/modules, impacts, execution strategy, tests, risks, rollback, and the profile-specific gates that genuinely apply. Keep the solution proportional; a profile label does not authorize unrelated abstraction or migration.

Default to `single`. Choose `parallel` only when at least two bounded workstreams have independent deliverables, clear dependencies, and disjoint write scopes, and delegation materially improves speed or quality. Use `coordinated` when workstreams exist but must be serialized. When subagents are available, prefer them for independent exploration, testing, and review. Do not create durable child task directories merely to mirror temporary agents.

Set status to `PLANNED`. For a standard task, continue only when approval is `approved`, or when explicit authorization makes `not_required` valid under the repository rules. High-risk tasks always require human approval.

## Implement

Use `.ai/prompts/implement.md`. Set status to `IMPLEMENTING`, stay within the approved plan and selected architecture boundaries, and preserve unrelated changes. If the approved strategy is `parallel` and subagents are available, delegate only the bounded workstreams recorded in the plan, wait for their results, and integrate them in the main agent. Serialize work if scopes overlap or dependencies change. If scope or risk changes materially, update the plan and renew approval when required.

Record the actual changes and plan deviations in `result.md`. Local checks used while coding are implementation feedback, not the independent test conclusion. When implementation is complete, set status to `TESTING`; do not set `VERIFIED` during this stage.

## Test

Use `.ai/prompts/test.md`. Read `task.md`, `plan.md`, and `result.md`, then independently execute the risk-appropriate test plan. Cover acceptance criteria, affected regression paths, format/static/type checks, unit tests, integration or E2E tests, build, and applicable security, migration, performance, compatibility, or operations checks.

Record exact commands, environment, outcomes, skipped checks, alternative evidence, failures, reruns, and residual risk in `test.md`. Independent test lanes may use subagents when worthwhile, but the main agent must verify and consolidate their evidence. For `enterprise`, include the applicable performance, resilience, security, observability, contract, release, and rollback evidence. If a failure requires code changes, return the task to `IMPLEMENTING`, fix it, and rerun the affected and regression checks. Set `test_status: passed` and status `VERIFIED` only after all required tests pass.

## Review

Use `.ai/prompts/review.md`. Review the actual diff and `test.md` against the task, plan, delivery level, and architecture style. For a complex task, use independent review subagents when available and beneficial, then verify and deduplicate their findings in the main agent. Prioritize correctness, boundary cases, error recovery, concurrency and idempotency, security, compatibility, data changes, performance, observability, test sufficiency, documentation consistency, and avoidance of unjustified complexity. Do not approve when `test_status` is not `passed`.

Record actionable findings in `review.md`. `BLOCKER` and `HIGH` findings must be resolved and rechecked before `review_status: passed`. Mark the task `DONE` only when the repository's definition of done is satisfied.

## Validate

For an active task:

```bash
./.ai/scripts/ai-task-check.sh .ai/tasks/<task-directory>
./.ai/scripts/ai-doc-sync.sh .ai/tasks/<task-directory>
```

For the project and all tasks:

```bash
./.ai/scripts/ai-task-check.sh --all
AI_PROTOCOL_STRICT=1 ./.ai/scripts/ai-task-check.sh --all
```

Warnings are allowed while drafting. Strict mode must pass before reporting the workflow as complete. Explain any skipped checks or accepted residual risk rather than hiding them.
