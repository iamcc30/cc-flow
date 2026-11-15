# Structured Task Workflow

Use this multi-file procedure only for Full tasks. Light and Compact use SKILL.md; do not load these stage prompts for them.

If `.ai/workspace.yaml` applies, use [workspace-workflow.md](workspace-workflow.md) to resolve affected repositories and linked parent/child tasks before following this repository-local procedure.

## Create a task

Before planning, check `git status --short`, current branch, HEAD, upstream, and the intended integration branch from project rules or the PR target. Fetch the relevant remote refs, then compare HEAD with both upstream and the integration target using `git rev-list --left-right --count HEAD...<ref>` and `git merge-base --is-ancestor <ref> HEAD`. Do not assume a feature branch is current merely because it matches its upstream. Resolve an unknown integration target before synchronization; do not guess main or master.

On a clean branch that is strictly behind its upstream, use `git merge --ff-only <upstream>` within the agreed workflow. If the target is ahead, or the tree is dirty or diverged, preserve user changes and choose an in-scope merge/rebase or a fresh workspace from the target. Do not reset, force-push, or automatically stash changes. If safe synchronization needs a missing user choice, explain it before editing. Failed fetch means unverified, not up to date; disclose it and obtain agreement before developing on that baseline. Local-only repositories record N/A. Record branch, HEAD, target ref/SHA, fetch outcome, and synchronization decision once in plan.md. Recheck on resumption or when the target changes. Git operations themselves do not create separate CC Flow tasks.

Use `.ai/prompts/understand.md` as stage guidance. Read the user's original request, required project context, and relevant repository evidence before defining scope.

Perform a lightweight product-intent check before creating a new task directory. Derive the product goal, user scenario, and observable success criteria from evidence. If a missing answer would materially change scope, user value, business behavior, or acceptance, ask at most 1–3 concise questions and stop before planning or implementation. Do not ask when the evidence is already sufficient, or when a clear bug, mechanical change, or approved decision already defines the outcome.

When the request names an implementation, UI, component, technology, or architecture, record it separately from the user need. Treat it as a candidate solution unless explicitly mandated or required by project evidence; Plan compares viable alternatives and states the recommendation and tradeoffs.

After the intent check, classify the task using `.ai/conventions.md`; simple tasks may use the lightweight path allowed there.

For a standard or high-risk task, resolve a lowercase hyphenated slug, a clear title, and the owner if known. If no matching active task exists, run from the repository root:

```bash
CC_FLOW_TASK_MODE=full ./.ai/scripts/ai-task-start.sh <slug> "<task title>" [owner]
```

Complete `task.md` from the user's request and repository evidence. The creation script snapshots `.ai/profile.md` into the task. Keep the user goal, scenario, success criteria, and any user-proposed solution distinct. Define observable success criteria without prescribing an unapproved implementation. Mark remaining unknowns without inventing facts or business rules. Keep status `DRAFT` and approval `pending` until the Plan stage changes them.

The script stores the task at `.ai/tasks/YYYY/MM/DD/HHMMSS-<slug>/` and assigns the ID `YYYY-MM-DD-HHMMSS-<slug>`. The local creation time provides deterministic same-day display order; it does not represent priority or dependency order. Treat the ID as the stable cross-repository reference.

Legacy dated directories such as `.ai/tasks/YYYY-MM-DD/<slug>/` and older flat directories such as `.ai/tasks/YYYY-MM-DD-<slug>/` remain valid and do not need to be moved.

## Plan

Use task.md as the requirement source without restating it. For each material decision cite evidence, identify the smallest viable change, and name the confirmed requirement that makes extra complexity necessary. Mark unverified assumptions and how to test them. Do not invent competing designs to fill a table. Evidence already supports a suitable reuse option? Stop searching. A short plan is sufficient when risk is low.

Read the required project context, `.ai/profile.md`, and the new task. Use `.ai/prompts/plan.md` as stage guidance. Perform read-only investigation and complete `plan.md` with the goal/solution distinction, current implementation, viable alternatives, recommendation and tradeoffs, concrete files/modules, impacts, execution strategy, tests, risks, rollback, and the profile-specific gates that genuinely apply.

Before proposing new code, record the reuse search in this order: suitable project implementations and patterns; standard-library or framework capabilities; already-declared dependencies; mature third-party libraries; custom implementation. Reuse only when semantics and boundaries fit. For a new dependency, explain why existing options are insufficient and assess compatibility, maintenance, security, license, size/runtime or operational cost, and testability using current authoritative evidence. Do not add a dependency for trivial behavior when a small local implementation is clearer and cheaper.

In the existing reuse assessment, name the default entry point, reference implementation and affected callers; justify departures from the project pattern. For replacements, include migration/cleanup or the reason, owner and exit condition for necessary coexistence, following `.ai/conventions.md`. Do not add a governance document or approval stage.

Default to `single`. Choose `parallel` only when at least two bounded workstreams have independent deliverables, clear dependencies, and disjoint write scopes, and delegation materially improves speed or quality. Use `coordinated` when workstreams exist but must be serialized. When subagents are available, prefer them for independent exploration, testing, and review. Do not create durable child task directories merely to mirror temporary agents.

Set status to `PLANNED`. For a standard task, continue only when approval is `approved`, or when explicit authorization makes `not_required` valid under the repository rules. High-risk tasks always require human approval.

## Implement

Use `.ai/prompts/implement.md`. Set status to `IMPLEMENTING`, stay within the approved plan and selected architecture boundaries, and preserve unrelated changes. Follow the approved reuse/dependency decision instead of recreating equivalent helpers, components, services, or infrastructure. If the approved strategy is `parallel` and subagents are available, delegate only the bounded workstreams recorded in the plan, wait for their results, and integrate them in the main agent. Serialize work if scopes overlap or dependencies change. If scope or risk changes materially, update the plan and renew approval when required.

Record the actual changes and plan deviations in `result.md`. Local checks used while coding are implementation feedback, not the independent test conclusion. When implementation is complete, set status to `TESTING`; do not set `VERIFIED` during this stage.

## Test

Use `.ai/prompts/test.md`. Read `task.md`, `plan.md`, and `result.md`, then independently execute the risk-appropriate test plan. Cover acceptance criteria, affected regression paths, format/static/type checks, unit tests, integration or E2E tests, build, and applicable security, migration, performance, compatibility, or operations checks.

Record exact commands, environment, outcomes, skipped checks, alternative evidence, failures, reruns, and residual risk in `test.md`. Independent test lanes may use subagents when worthwhile, but the main agent must verify and consolidate their evidence. For `enterprise`, include the applicable performance, resilience, security, observability, contract, release, and rollback evidence. If a failure requires code changes, return the task to `IMPLEMENTING`, fix it, and rerun the affected and regression checks. Set `test_status: passed` and status `VERIFIED` only after all required tests pass.

## Review

Use `.ai/prompts/review.md`. Review the actual diff and `test.md` against the task, plan, delivery level, and architecture style. For a complex task, use independent review subagents when available and beneficial, then verify and deduplicate their findings in the main agent. Prioritize correctness, boundary cases, error recovery, concurrency and idempotency, security, compatibility, data changes, performance, observability, test sufficiency, documentation consistency, unnecessary duplication, unjustified custom implementations, and disproportionate dependencies. Do not approve when `test_status` is not `passed`.

Record actionable findings in `review.md`. `BLOCKER` and `HIGH` findings must be resolved and rechecked before `review_status: passed`. Mark the task `DONE` only when the repository's definition of done is satisfied.

Also withhold approval for unexplained duplication, bypassed default entry points, or replacement paths without migration/retirement arrangements. Check affected existing callers against the test evidence, not only the new feature.

Routine branch integration, tagging/release, and deployment of an existing reviewed artifact through an established runbook happen outside CC Flow after the development task is done; do not reopen or create a task merely to record them. They remain subject to normal permissions and production authorization. If merge conflicts or deployment failures require semantic code/configuration changes, return to an active task or create a new task before editing.

## Validate

Keep documentation bounded: aim for one screen of project progress and one page per task document; these are editing targets, not reasons to omit critical evidence. Check affected facts against current code/configuration/tests and replace stale statements rather than append task diaries. In result.md's document-sync section, list only changed docs and facts, or one reason no update was needed; do not require a progress edit or a per-document no-change checklist. Full logs, screenshots and builds belong outside `.ai/` in existing artifact storage, linked from test.md with temporary evidence identified; product tests and fixtures belong in the project's test locations. Task directories contain Markdown evidence only. Optional sections may be removed; required headings may contain a concise N/A reason. Archive completed tasks only when requested, preserve IDs/links, and exclude archives from routine reads. Do not scan all history to answer an active task question.

For an active task:

```bash
./.ai/scripts/ai-task-check.sh .ai/tasks/<YYYY>/<MM>/<DD>/<HHMMSS-slug>
./.ai/scripts/ai-doc-sync.sh .ai/tasks/<YYYY>/<MM>/<DD>/<HHMMSS-slug>
```

For the project and all tasks:

```bash
./.ai/scripts/ai-task-check.sh --all
AI_PROTOCOL_STRICT=1 ./.ai/scripts/ai-task-check.sh --all
```

Warnings are allowed while drafting. Strict mode must pass before reporting the workflow as complete. Explain any skipped checks or accepted residual risk rather than hiding them.
