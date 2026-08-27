# Multi-Repository Workspace Workflow

Use this procedure when one product spans multiple repositories, when `.ai/workspace.yaml` exists, or when a brief request may require coordinated changes across repositories.

## 1. Resolve the workspace

Look for `.ai/workspace.yaml` in the current repository and available workspace roots. If exactly one valid configuration applies, use it without asking the user to repeat repository paths. If none exists and the request is clearly repository-local, use the normal task workflow. If none exists and multiple repositories must be coordinated, initialize a workspace only after identifying the intended coordinator repository and repository roles from evidence or the user.

Create a draft with:

```bash
<skill-directory>/scripts/init-workspace.sh <coordinator-repository>
```

Replace every placeholder in `.ai/workspace.yaml`. Keep the configuration small: workspace name, coordinator key, and repository key/path/role entries. Paths are resolved relative to the coordinator repository. Do not add credentials, remote URLs with embedded tokens, branch names, or temporary worktree paths.

Validate that every configured path exists, is the intended repository root, and has no conflicting CC Flow instructions. Initialize missing repository-local CC Flow files only when the user requested workspace setup or the repository is clearly in scope; preserve existing files and local customizations.

## 2. Interpret a brief request

A short request is the product intent, not a task template the user must expand. Inspect the coordinator context and relevant repository evidence, then determine:

- the product-level outcome and likely acceptance boundaries;
- which configured repositories are genuinely affected;
- interface, data, compatibility, security, privacy, operations, and release dependencies;
- facts that can be derived from code, tests, contracts, and maintained documentation;
- decisions that only the product owner can make.

Do not assume every repository must change. Conversely, do not interpret a client-facing feature as client-only when server APIs, administration, contracts, or rollout support are required.

Ask only a consolidated set of unresolved questions that materially change scope, business behavior, risk, or acceptance. Present evidence-backed defaults as proposals, never as established project facts.

## 3. Create linked tasks

Create one parent task in the coordinator repository and one child task in each affected code repository. Use the same concise slug stem and title vocabulary. Create tasks with repository-local scripts; set linkage metadata through environment variables:

```bash
CC_FLOW_REPOSITORY_ROLE=coordinator \
  ./.ai/scripts/ai-task-start.sh <slug> "<product task title>" [owner]

CC_FLOW_PARENT_TASK=<parent-task-id> \
CC_FLOW_REPOSITORY_ROLE=<workspace-repository-key> \
  ./.ai/scripts/ai-task-start.sh <slug> "<repository task title>" [owner]
```

Fill the parent task with product scope, cross-repository acceptance criteria, workstreams, dependencies, integration tests, compatibility, rollout, and overall completion conditions. Fill each child task only with that repository's responsibilities and link it to the parent. Do not duplicate detailed repository implementation plans in the parent task.

Task creation and read-only planning are allowed by a brief development request. Product-code modification still follows each repository's approval and risk rules. High-risk work always stops for approval.

## 4. Plan and coordinate

Plan affected repositories from dependency boundaries outward. Establish or update interface contracts before parallel implementation where practical. Record the expected merge and deployment order, backward-compatibility window, feature-flag needs, integration environment, and rollback ownership in the parent plan.

Each child plan must use the repository's own profile, architecture, conventions, test commands, and approval gate. A parent approval does not silently waive a stricter child-repository gate. If a child discovers a material scope or contract change, update the parent plan and affected sibling plans before continuing.

## 5. Implement, test, review, and finish

Run the normal task workflow independently in each affected repository. Keep repository-local test evidence local. The parent task may reach `DONE` only when:

- all required child tasks are complete or explicitly deferred with accepted consequences;
- cross-repository contracts are consistent;
- integration or end-to-end acceptance has actual recorded evidence;
- compatibility, rollout order, rollback, and residual risks are documented;
- durable product facts live in the coordinator, while implementation facts live in their owning repositories.

Do not mark unavailable environments or unrun integration checks as passed. Do not create remote issues, branches, pull requests, pushes, releases, or production changes unless the user separately authorizes those external mutations.

## 6. Documentation ownership

- Coordinator: product scope, shared business rules, cross-repository architecture, overall acceptance, compatibility, and rollout.
- Owning repository: implementation architecture, framework conventions, API or schema source, build/test commands, operations, and repository task evidence.
- `.ai/tasks/`: auditable task process and evidence.
- Long-lived `docs/` or contract files: durable human-facing truth. `.ai/` should summarize and link rather than copy it.

When no durable fact changed, record `NOT_NEEDED` with a reason instead of creating ceremonial documentation.
