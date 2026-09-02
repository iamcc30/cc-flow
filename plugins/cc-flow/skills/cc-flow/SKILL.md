---
name: cc-flow
description: Turn requested software changes into an auditable Understand/Plan/Implement/Test/Review workflow. Use when implementing or modifying features, fixing bugs, refactoring or optimizing code, changing tests/configuration/schemas/dependencies/build/deployment, continuing an active CC Flow task, or initializing/refreshing CC Flow across one or more repositories. Do not use for read-only questions, explanations, exploration, research, reports, summaries, status checks, or standalone document creation unless explicitly invoked.
---

# CC Flow

Create and operate a durable AI software-development workflow inside each repository. A configured workspace may coordinate several repositories, but each repository remains the source of truth for its own code, rules, task evidence, and approvals.

## Scope

- Invoke implicitly only when the request may change software code, behavior, tests, technical configuration, data schemas, dependencies, build/deployment mechanics, or CC Flow itself.
- Continue using it for the remaining Plan, Implement, Test, Review, and Document stages of an already active CC Flow task.
- Do not create or update `.ai/tasks/`, `.ai/progress.md`, or other workflow evidence for read-only questions, explanations, repository exploration, research, reports, summaries, status checks, or standalone document generation. Read only the repository context needed to answer.
- Explicit invocation with `$cc-flow` always opts into the workflow. If a read-only conversation later becomes a change request, start the workflow before editing.

## Select the mode

- **Initialize or refresh a repository:** Read [references/initialize.md](references/initialize.md).
- **Initialize or operate a multi-repository workspace, or route a brief feature request across repositories:** Read [references/workspace-workflow.md](references/workspace-workflow.md).
- **Create, plan, implement, test, review, or validate a task:** Read [references/task-workflow.md](references/task-workflow.md).

Read only the references required by the current request. For a configured workspace request, read the workspace workflow first, then the task workflow for affected repositories. If initialization is also required, initialize before task execution.

## Invariants

- Do not treat the skill's template as project truth. Copy it into the target repository, then derive project-specific content from evidence.
- Treat a short request such as "add resident registration" as sufficient to start Understand, not implementation. First derive the product goal, user scenario, and success criteria from repository evidence. Ask at most 1–3 concise questions only when missing information would materially change scope, user value, or acceptance; do not repeat facts already available or turn every task into a product interview.
- Treat a user-proposed UI, technology, component, or architecture as a candidate solution unless the user or project evidence makes it a mandatory constraint. Keep the user goal, proposed solution, alternatives, and recommendation distinct.
- Prefer reuse before new implementation: inspect suitable project code and patterns first, then standard-library/framework capabilities and existing dependencies, then mature third-party libraries, and write custom code only when those options are unsuitable. Do not force reuse across incompatible semantics or boundaries. Evaluate any new dependency for fit, compatibility, maintenance, security, license, operational cost, and proportionality.
- A brief request does not authorize invented business rules, bypassed approval gates, new repositories, external issue/PR creation, pushes, releases, or production changes.
- Preserve existing repository instructions and unrelated user changes. The initializer refuses file conflicts by default; never use `--force` unless the user explicitly authorizes overwriting the listed protocol files.
- During context initialization, inspect only and do not modify product code.
- Do not invent goals, business rules, architecture, commands, owners, approvals, or test results. Mark unknowns and ask only for information that cannot be determined safely.
- Default to `standard + existing`. Recommend a different profile only from project evidence, never change it without confirmation, and never treat a profile change as authorization for an architecture migration.
- For standard and high-risk tasks, honor the repository's planning and approval gates before editing product code.
- Default to one agent. When subagents are available, delegate only if at least two bounded, independent workstreams materially improve speed or quality. Prefer parallel exploration, testing, and review; parallel code edits require disjoint write scopes and stable shared contracts.
- Subagents are temporary workers, not durable task records. Do not create task directories merely to mirror agents; the main agent owns approval, integration, task status, evidence, and documentation, and delegation never expands the task's permissions.
- Record exact verification commands and outcomes. Never present an unrun check as passed.
- Keep secrets, credentials, personal data, and production data out of `.ai/` task records.
- Project-specific `.ai/` files and `AGENTS.md` persist after the skill finishes and govern later work even when the skill is not invoked.

## Bundled resources

- `assets/repository-template/` is the installable repository overlay.
- `assets/workspace-template.yaml` is the starting schema for optional multi-repository coordination.
- `scripts/init-project.sh` installs the overlay without overwriting existing files by default.
- `scripts/init-workspace.sh` creates a workspace configuration draft in an initialized coordinator repository without overwriting an existing configuration.
- After installation, use the repository-local workflow scripts under `.ai/scripts/`; keeping them inside `.ai/` avoids mixing CC Flow helpers with product-owned scripts.
