---
name: cc-flow
description: Turn brief software requests into an auditable Plan/Implement/Test/Review workflow for one repository or a configured multi-repository workspace. Use for feature, bug, refactor, project-initialization, or workflow requests when a repository uses CC Flow's `.ai/` layout, or when the user asks to standardize AI development.
---

# CC Flow

Create and operate a durable AI software-development workflow inside each repository. A configured workspace may coordinate several repositories, but each repository remains the source of truth for its own code, rules, task evidence, and approvals.

## Select the mode

- **Initialize or refresh a repository:** Read [references/initialize.md](references/initialize.md).
- **Initialize or operate a multi-repository workspace, or route a brief feature request across repositories:** Read [references/workspace-workflow.md](references/workspace-workflow.md).
- **Create, plan, implement, test, review, or validate a task:** Read [references/task-workflow.md](references/task-workflow.md).

Read only the references required by the current request. For a configured workspace request, read the workspace workflow first, then the task workflow for affected repositories. If initialization is also required, initialize before task execution.

## Invariants

- Do not treat the skill's template as project truth. Copy it into the target repository, then derive project-specific content from evidence.
- Treat a short request such as "add resident registration" as sufficient to start discovery and planning. Do not require the user to restate repository paths, templates, or workflow steps already recorded in `.ai/workspace.yaml` and repository context.
- A brief request does not authorize invented business rules, bypassed approval gates, new repositories, external issue/PR creation, pushes, releases, or production changes.
- Preserve existing repository instructions and unrelated user changes. The initializer refuses file conflicts by default; never use `--force` unless the user explicitly authorizes overwriting the listed protocol files.
- During context initialization, inspect only and do not modify product code.
- Do not invent goals, business rules, architecture, commands, owners, approvals, or test results. Mark unknowns and ask only for information that cannot be determined safely.
- Default to `standard + existing`. Recommend a different profile only from project evidence, never change it without confirmation, and never treat a profile change as authorization for an architecture migration.
- For standard and high-risk tasks, honor the repository's planning and approval gates before editing product code.
- Record exact verification commands and outcomes. Never present an unrun check as passed.
- Keep secrets, credentials, personal data, and production data out of `.ai/` task records.
- Project-specific `.ai/` files and `AGENTS.md` persist after the skill finishes and govern later work even when the skill is not invoked.

## Bundled resources

- `assets/repository-template/` is the installable repository overlay.
- `assets/workspace-template.yaml` is the starting schema for optional multi-repository coordination.
- `scripts/init-project.sh` installs the overlay without overwriting existing files by default.
- `scripts/init-workspace.sh` creates a workspace configuration draft in an initialized coordinator repository without overwriting an existing configuration.
- After installation, use the repository-local scripts under `scripts/`; they are versioned with the project and can evolve with it.
