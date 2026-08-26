# Initialize or Refresh a Repository

Use this procedure when setting up the workflow, filling `{{...}}` context fields, or updating an existing installation.

## 1. Resolve and inspect the target

Identify the repository root from the user's target or the current Git root. Before writing, inspect:

- Existing `AGENTS.md`, `CLAUDE.md`, `.ai/`, `.cursor/`, `.github/`, and `scripts/` files that may conflict.
- Project documentation, manifests, source layout, tests, CI, deployment configuration, interfaces, and migrations.
- The working tree so unrelated changes remain untouched.

If the target is ambiguous and choosing incorrectly could modify a different repository, ask for the target path.

## 2. Install the overlay

Run the skill's initializer with the resolved repository root:

```bash
<skill-directory>/scripts/init-project.sh <repository-root>
```

The script performs a complete preflight and makes no changes if any target protocol file already exists. If conflicts exist, inspect and merge them deliberately. Do not use `--force` unless the user explicitly asks to replace those files after seeing the conflict scope.

For a repository already using this layout, do not reinstall blindly. Compare the bundled template with the repository's customized files and update only the requested reusable mechanics while preserving project facts and local rules.

## 3. Build the context draft

Read the installed `AGENTS.md` and `.ai/conventions.md`. Fill project files from observable evidence:

- `.ai/profile.md`: keep `standard + existing` by default. Recommend another delivery level or architecture style only when project evidence justifies it; obtain confirmation before changing the fields.
- `.ai/project.md`: purpose, users, scope, constraints, and links.
- `.ai/architecture.md`: modules, dependency directions, storage, external systems, quality attributes, and real commands.
- `.ai/business.md`: only business terminology, rules, roles, states, and flows supported by code, tests, docs, or the user.
- `.ai/progress.md`: current phase, completed capabilities, active work, risks, and next actions.
- `.ai/conventions.md`: actual format, lint, typecheck, test, build, and integration commands; use `N/A` when genuinely inapplicable.

Keep a short evidence trail in the work summary. Do not edit product code during initialization.

## 4. Resolve unknowns

Search remaining placeholders. Separate them into:

- Facts discoverable with more repository inspection.
- Decisions only the user or project owner can make, such as business goals, non-goals, success metrics, compliance expectations, ownership, and risk tolerance.

Profile selection belongs to the second category when it changes delivery obligations or architecture. Do not automatically select `enterprise` because a repository is large, or `ddd` because it contains domain-named classes.

Ask concise questions only for the second category. Update the files after receiving answers.

The decision template in `.ai/decisions.md` intentionally retains placeholders and does not need to be instantiated until a real durable decision exists.

## 5. Validate

Run:

```bash
./scripts/ai-task-check.sh --project
AI_PROTOCOL_STRICT=1 ./scripts/ai-task-check.sh --project
```

Use the first command while drafting. Strict mode should pass before declaring initialization complete. Report installed files, inferred facts, user-supplied decisions, validation outcome, and any remaining unknowns.
