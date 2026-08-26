# Structured Task Workflow

Use this procedure after the repository contains the CC Flow layout.

## Create a task

Resolve a lowercase hyphenated slug, a clear title, and the owner if known. Run from the repository root:

```bash
./scripts/ai-task-start.sh <slug> "<task title>" [owner]
```

Complete `task.md` from the user's request and repository evidence. The creation script snapshots `.ai/profile.md` into the task. Do not invent acceptance criteria that materially change scope. Classify risk using `.ai/conventions.md`.

## Plan

Read the required project context, `.ai/profile.md`, and the new task. Use `.ai/prompts/plan.md` as stage guidance. Perform read-only investigation and complete `plan.md` with concrete files/modules, impacts, tests, risks, rollback, and the profile-specific gates that genuinely apply. Keep the solution proportional; a profile label does not authorize unrelated abstraction or migration.

Set status to `PLANNED`. For a standard task, continue only when approval is `approved`, or when explicit authorization makes `not_required` valid under the repository rules. High-risk tasks always require human approval.

## Implement

Use `.ai/prompts/implement.md`. Set status to `IMPLEMENTING`, stay within the approved plan and selected architecture boundaries, and preserve unrelated changes. If scope or risk changes materially, update the plan and renew approval when required.

Record the actual changes and plan deviations in `result.md`. Local checks used while coding are implementation feedback, not the independent test conclusion. When implementation is complete, set status to `TESTING`; do not set `VERIFIED` during this stage.

## Test

Use `.ai/prompts/test.md`. Read `task.md`, `plan.md`, and `result.md`, then independently execute the risk-appropriate test plan. Cover acceptance criteria, affected regression paths, format/static/type checks, unit tests, integration or E2E tests, build, and applicable security, migration, performance, compatibility, or operations checks.

Record exact commands, environment, outcomes, skipped checks, alternative evidence, failures, reruns, and residual risk in `test.md`. For `enterprise`, include the applicable performance, resilience, security, observability, contract, release, and rollback evidence. If a failure requires code changes, return the task to `IMPLEMENTING`, fix it, and rerun the affected and regression checks. Set `test_status: passed` and status `VERIFIED` only after all required tests pass.

## Review

Use `.ai/prompts/review.md`. Review the actual diff and `test.md` against the task, plan, delivery level, and architecture style. Prioritize correctness, boundary cases, error recovery, concurrency and idempotency, security, compatibility, data changes, performance, observability, test sufficiency, documentation consistency, and avoidance of unjustified complexity. Do not approve when `test_status` is not `passed`.

Record actionable findings in `review.md`. `BLOCKER` and `HIGH` findings must be resolved and rechecked before `review_status: passed`. Mark the task `DONE` only when the repository's definition of done is satisfied.

## Validate

For an active task:

```bash
./scripts/ai-task-check.sh .ai/tasks/<task-directory>
./scripts/ai-doc-sync.sh .ai/tasks/<task-directory>
```

For the project and all tasks:

```bash
./scripts/ai-task-check.sh --all
AI_PROTOCOL_STRICT=1 ./scripts/ai-task-check.sh --all
```

Warnings are allowed while drafting. Strict mode must pass before reporting the workflow as complete. Explain any skipped checks or accepted residual risk rather than hiding them.
