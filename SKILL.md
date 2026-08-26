---
name: cc-flow
description: Initialize and operate a repository-local, auditable AI development workflow. Use when the user asks to standardize AI coding, initialize project context and AGENTS.md, create or run a structured development task, enforce Plan/Implement/Test/Review gates, or when a repository already uses the `.ai/conventions.md` layout from this skill.
---

# CC Flow

Create and operate a durable AI software-development workflow inside each repository. The skill supplies reusable mechanics; the repository remains the source of truth for project facts, rules, task evidence, and approvals.

## Select the mode

- **Initialize or refresh a repository:** Read [references/initialize.md](references/initialize.md).
- **Create, plan, implement, test, review, or validate a task:** Read [references/task-workflow.md](references/task-workflow.md).

Read only the reference required by the current request. If a request includes initialization and task execution, initialize first, then read the task workflow.

## Invariants

- Do not treat the skill's template as project truth. Copy it into the target repository, then derive project-specific content from evidence.
- Preserve existing repository instructions and unrelated user changes. The initializer refuses file conflicts by default; never use `--force` unless the user explicitly authorizes overwriting the listed protocol files.
- During context initialization, inspect only and do not modify product code.
- Do not invent goals, business rules, architecture, commands, owners, approvals, or test results. Mark unknowns and ask only for information that cannot be determined safely.
- For standard and high-risk tasks, honor the repository's planning and approval gates before editing product code.
- Record exact verification commands and outcomes. Never present an unrun check as passed.
- Keep secrets, credentials, personal data, and production data out of `.ai/` task records.
- Project-specific `.ai/` files and `AGENTS.md` persist after the skill finishes and govern later work even when the skill is not invoked.

## Bundled resources

- `assets/repository-template/` is the installable repository overlay.
- `scripts/init-project.sh` installs the overlay without overwriting existing files by default.
- After installation, use the repository-local scripts under `scripts/`; they are versioned with the project and can evolve with it.
