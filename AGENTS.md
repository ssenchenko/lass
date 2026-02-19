# AGENTS.md — Monorepo rules

## Repo layout
- `.github/` : CI workflows + shared scripts
- `terraform/` : Infrastructure as Code (Terraform)
- `web/` : SvelteKit app + Firebase App Hosting + emulators (Docker)

## General workflow
- Prefer small, reviewable diffs.
- Don’t refactor unrelated code.
- If requirements are unclear, ask 1–3 targeted questions before large edits.

## Git Workflow & Branching
- Always create a new **feature branch** for each change/task:
  - Branch names should follow: `feature/<short-description>` or `fix/<short-description>`
  - Do NOT commit code directly to `main`, `develop`, or protected branches.

- Codex should NOT push directly to protected branches.
- Codex should propose changes via a **draft Pull Request** when possible.
- Each commit should be atomic: focus on one feature/fix and reference the task/issue.
- Commit messages should be clear and follow conventions (`feat:` / `fix:` / `chore:` prefix).
- Humans must review all AI-generated code before merging.

## CI / GitHub Actions
- Workflows live in `.github/workflows/`
- Any change must keep CI green.
- If you add/rename scripts in `web/`, update `.github` workflows/scripts accordingly.
- Do not change lockfiles unless intentionally updating dependencies.

## Local commands by folder
- `web/`: use the `npm run ...` scripts from `web/package.json`
- `terraform/`: use Terraform CLI commands in the relevant module/dir

## Terraform guardrails
- Prefer minimal, safe changes. No broad refactors.
- Run formatting/validation when changing IaC:
  - `terraform fmt -recursive`
  - `terraform validate` (in the relevant module/dir)
- Never commit secrets. Use variables and secret managers.
- If changing resources that affect prod, call it out explicitly.

## Output format when responding
When implementing a change:
1) approach summary
2) files changed
3) commands to run locally (and from which folder)
4) risks / follow-ups
