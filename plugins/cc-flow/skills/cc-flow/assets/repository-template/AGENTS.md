# Repository Instructions for Codex

These instructions apply to the entire repository. More specific `AGENTS.md` files may add stricter rules for subdirectories but must not weaken this protocol.

## Required context

Before planning or editing, read:

1. `.ai/workspace.yaml`, when present
2. `.ai/project.md`
3. `.ai/profile.md`
4. `.ai/architecture.md`
5. `.ai/business.md`
6. `.ai/conventions.md`
7. `.ai/progress.md`
8. The active task under `.ai/tasks/`, when one exists

## Required workflow

Follow `.ai/conventions.md` as the source of truth.

- Keep changes within the task scope.
- When `.ai/workspace.yaml` applies, coordinate through its parent task but keep implementation evidence in the owning repository.
- For non-simple tasks, create or complete the task plan before editing code.
- Do not claim tests passed unless they were actually run; record exact commands and outcomes.
- Do not overwrite unrelated user changes.
- Update project documentation when business behavior, architecture, interfaces, operations, or progress changes.
- Record durable decisions in `.ai/decisions.md`.
- Never place secrets or sensitive production data in task files.

If instructions conflict, stop and report the conflict. Repository facts and explicit user instructions take precedence over generic assumptions, while safety and security rules always remain in force.
