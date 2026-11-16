---
name: cc-flow
description: Turn requested software changes into an auditable Understand/Plan/Implement/Test/Review workflow. Use when implementing or modifying features, fixing bugs, refactoring or optimizing code, changing tests/configuration/schemas/dependencies/build or deployment configuration, continuing an active CC Flow task, or initializing/refreshing CC Flow across repositories, including “升级当前项目的 cc-flow”. Do not use for read-only work, standalone documents, routine Git integration, release/tagging, or routine deployment execution unless explicitly invoked or code/configuration changes are required.
---

# CC Flow

Create and operate a durable AI software-development workflow inside each repository. A configured workspace may coordinate several repositories, but each repository remains the source of truth for its own code, rules, task evidence, and approvals.

## Scope

- Invoke implicitly only when the request may change software code, behavior, tests, technical configuration, data schemas, dependencies, build or deployment configuration, or CC Flow itself.
- Continue using it for the remaining Plan, Implement, Test, Review, and Document stages of an already active CC Flow task.
- Do not create or update `.ai/tasks/`, `.ai/progress.md`, or other workflow evidence for read-only questions, explanations, repository exploration, research, reports, summaries, status checks, or standalone document generation. Read only the repository context needed to answer.
- Do not create or update CC Flow evidence for routine merge/rebase/cherry-pick operations, tagging or release execution, or routine deployment of an existing reviewed artifact through an established runbook. These operations still obey normal permission, safety, and production-authorization requirements. If conflict resolution or a failed deployment requires semantic code/configuration changes, enter or resume CC Flow before making those changes.
- Explicit invocation with `$cc-flow` always opts into the workflow. If a read-only conversation later becomes a change request, start the workflow before editing.

## Select the mode

Select effort before reading references or creating files:
- **Light:** bounded, low-risk, easy-to-verify changes, even across several files. Explain briefly, implement, run targeted checks, inspect the diff, summarize. No task directory or progress update unless durable project facts changed. No automatic initialization.
- **Compact (default for ordinary features):** one task.md contains goal, evidence-backed plan/baseline, verification and result. Use the compact procedure below.
- **Full:** cross-repository coordination, genuinely complex work, or high-risk data/security/payment/compatibility changes. Read the full task reference. High-risk plans require human approval.

Do not classify by file count. Explicit invocation selects CC Flow, not necessarily Full. Existing tasks keep their format. Repository-specific stricter requirements still apply; disclose conflicts instead of silently downgrading.

### Compact procedure

Read applicable repository rules and relevant code/tests, not all project context. Reuse already-loaded unchanged context; load architecture/business/profile only when relevant. Do not read history or every stage prompt. Check the Git baseline as described in the first two paragraphs of the task reference before editing; record it once in task.md (Light: in the work summary).

For an initialized repository run `.ai/scripts/ai-task-start.sh <slug> "<title>" [owner]`; it creates only task.md at `.ai/tasks/YYYY/MM/DD/HHMMSS-<slug>/`. Do not install the full overlay just to make a small change. If initialization is not requested, use a concise in-conversation record.

Clarify only material unknowns. Record the smallest viable plan with concrete evidence. Respect project approval rules; explicit authorization can support not_required for ordinary tasks, never high-risk work. Implement, run risk-appropriate tests, then review the actual diff. Store commands, outcomes, skipped checks and residual risk once; test_status and review_status become passed only with actual evidence. Set DONE only when acceptance and required checks pass. Validate only the active record with ai-task-check.sh, not --all. The checker validates structure, not truth or quality.

Update durable docs only when facts changed, never solely to record activity. Keep logs in artifacts, use links/short failure excerpts. Default to one agent; no extra agent merely to satisfy a stage. If complexity or risk increases, switch to Full before risky edits, preserve the ID and existing evidence, add needed full templates and use protocol v4; do not create a duplicate task.

- **Initialize or refresh a repository:** Read [references/initialize.md](references/initialize.md). “升级当前项目的 cc-flow” means merge the installed skill's current workflow into the current repository, preserving configuration, local rules and history, without extra backups. This is sufficient authorization for that refresh; do not ask the user to restate these defaults. Updating the installed skill itself is a separate request.
- **Initialize or operate a multi-repository workspace, or route a brief feature request across repositories:** Read [references/workspace-workflow.md](references/workspace-workflow.md).
- **Full task only:** Read [references/task-workflow.md](references/task-workflow.md). Its multi-file requirements do not apply to Light or Compact.

Read only the references required by the current request. For a configured workspace request, read the workspace workflow first, then the task workflow for affected repositories. If initialization is also required, initialize before task execution.

## Invariants

- Before planning and again before editing after a pause, follow the baseline check in `references/task-workflow.md`: verify both upstream and target integration refs after fetching. Never silently develop on a stale or unverified baseline.
- Ground important decisions in code, tests, call paths, measurements, or authoritative references. Start with the smallest viable change; added abstraction or dependencies need a confirmed requirement the simple option cannot meet. Future extensibility alone is insufficient.
- Keep one source per fact: Compact uses task.md only; Full separates requirements, decisions, tests, deviations and findings. Link rather than repeat; read historical tasks only on demand.
- Verify relevant documentation against current code, configuration and tests before relying on it; age alone does not prove staleness. Correct affected current facts in the same change, linking to existing authoritative docs instead of copying them. Historical task records describe their original baseline, not current behavior. Keep progress as a current snapshot, not a growing completion log.
- Keep `.ai/` for workflow resources, concise project context and Markdown task evidence. Product tests/fixtures belong in the project's existing test locations; product scripts belong outside `.ai/scripts/`, which is reserved for workflow helpers. Put logs, screenshots, builds and other generated output in existing artifact storage or temporary directories outside `.ai/`; record commands, outcomes and stable evidence links, noting temporary evidence. Do not add parallel reports or automatically move/delete historical files to clean up.
- Do not treat the skill's template as project truth. Copy it into the target repository, then derive project-specific content from evidence.
- Treat a short request such as "add resident registration" as sufficient to start Understand, not implementation. First derive the product goal, user scenario, and success criteria from repository evidence. Ask at most 1–3 concise questions only when missing information would materially change scope, user value, or acceptance; do not repeat facts already available or turn every task into a product interview.
- Treat a user-proposed UI, technology, component, or architecture as a candidate solution unless the user or project evidence makes it a mandatory constraint. Keep the user goal, proposed solution, alternatives, and recommendation distinct.
- Prefer reuse before new implementation: inspect suitable project code and patterns first, then standard-library/framework capabilities and existing dependencies, then mature third-party libraries, and write custom code only when those options are unsuitable. Do not force reuse across incompatible semantics or boundaries. Evaluate any new dependency for fit, compatibility, maintenance, security, license, operational cost, and proportionality.
- For all modes, identify the existing entry point, a representative implementation, and relevant callers before adding a feature. Follow the project's default pattern; a new entry point, abstraction, or implementation style needs a concrete requirement the existing approach cannot meet. A failed name search alone is not evidence of absence: inspect the adjacent business flow. Record this briefly in the existing plan (Light: work summary), not a new checklist or approval stage.
- When replacing an implementation, account for callers, tests, fixtures, configuration and exports; migrate and remove obsolete paths within scope. Necessary coexistence needs a reason, a known owner (or an explicit unresolved ownership issue), and a verifiable exit condition in the same plan. Review must reject unexplained duplication, bypasses of the default entry point, and replacement paths without a migration/retirement plan; regression checks must cover affected existing callers.
- Keep default entry points and reference examples in the existing architecture module table, using verified code rather than inventing a catalog. Enforce mechanically checkable project boundaries through existing lint/tests/CI where practical, on new changes first; do not introduce a generic governance framework or rewrite unrelated legacy code.
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
