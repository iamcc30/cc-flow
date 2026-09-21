# Repository Instructions for Codex

These instructions apply to the entire repository. More specific `AGENTS.md` files may add stricter rules for subdirectories but must not weaken this protocol.

## Applicability

Apply the CC Flow workflow when a request may modify software code, behavior, tests, technical configuration, data schemas, dependencies, build or deployment configuration, or CC Flow itself, and when continuing an active CC Flow task.

Read-only questions, explanations, repository exploration, research, reports, summaries, status checks, and standalone document creation must not create or update `.ai/tasks/`, `.ai/progress.md`, or other workflow evidence unless the user explicitly invokes CC Flow. Read only the files needed to answer. If the request later becomes a software change, start the workflow before editing.

Routine merge/rebase/cherry-pick operations, tagging or release execution, and routine deployment of an existing reviewed artifact through an established runbook also stay outside CC Flow. They still require normal permission and production-safety checks. If conflict resolution or deployment failure requires semantic code/configuration changes, start or resume CC Flow before editing.

## Required context

Before development, fetch relevant remote refs and check both upstream and the intended integration branch. Safely synchronize a clean behind branch; preserve dirty/diverged work. Record the baseline in the plan and disclose failed fetches or stale targets before editing.

Read applicable rules and relevant code/tests. Load project context only when needed, reuse unchanged context already loaded, and do not preload every file, stage prompt or historical task.

## Required workflow

For work in scope above, follow `.ai/conventions.md` as the source of truth.

Choose effort by risk, not file count: Light needs no task directory; ordinary features use one compact task.md; complex, cross-repository or high-risk work uses Full. Separate plan/test/result/review files and stage prompts apply only to Full. Do not initialize the overlay merely for a small change.

- Keep changes within the task scope.
- Important decisions need concrete evidence and a smallest-change alternative; speculative future needs do not justify complexity. Requirements, plans and test evidence each have one source; reference instead of copying. Read only the active task and relevant project context, not all historical tasks.
- When `.ai/workspace.yaml` applies, coordinate through its parent task but keep implementation evidence in the owning repository.
- For non-simple tasks, create or complete the task plan before editing code.
- Before adding code or dependencies, prefer suitable project implementations, platform/framework capabilities, existing dependencies, and mature third-party libraries in that order; do not force reuse when semantics or boundaries differ.
- Do not claim tests passed unless they were actually run; record exact commands and outcomes.
- Do not overwrite unrelated user changes.
- Update project documentation when business behavior, architecture, interfaces, operations, or progress changes.
- Record durable decisions in `.ai/decisions.md`.
- Never place secrets or sensitive production data in task files.

If instructions conflict, stop and report the conflict. Repository facts and explicit user instructions take precedence over generic assumptions, while safety and security rules always remain in force.
