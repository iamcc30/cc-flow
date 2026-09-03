# Repository Instructions for Claude Code

For requests that may change software code, behavior, tests, technical configuration, schemas, dependencies, build or deployment configuration, or CC Flow itself, read and follow `AGENTS.md` and `.ai/conventions.md` before making changes.

For read-only questions, explanations, exploration, research, reports, summaries, status checks, or standalone document creation, do not create or update CC Flow task records unless the user explicitly invokes it. Read only the context needed to answer.

Routine Git integration, tagging/release, and deployment of an existing reviewed artifact through an established runbook do not use CC Flow unless they require semantic code/configuration changes. Normal permission and production-safety requirements still apply.

The canonical project context is stored in:

- `.ai/project.md`
- `.ai/profile.md`
- `.ai/architecture.md`
- `.ai/business.md`
- `.ai/progress.md`
- `.ai/decisions.md`

Use the active directory under `.ai/tasks/` for the task brief, plan, result, and review. Do not bypass the planning, verification, documentation, or approval gates defined in `.ai/conventions.md`.
