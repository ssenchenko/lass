# web/AGENTS.md — SvelteKit + Firebase App Hosting (Authoritative)

This file defines how Codex should work in the `web/` package.
Follow these rules strictly. Do not guess defaults.

---

## Stack
- SvelteKit (Svelte 5) + TypeScript
- Adapter: `@sveltejs/adapter-node` (SSR Node app)
- Vite
- Tailwind CSS
- Firebase Hosting + Firebase App Hosting
- Local Firebase emulators run **in Docker** (preferred)
- Testing:
  - Vitest (node + browser projects)
  - Playwright (browser provider for Vitest + standalone E2E)

---

## Runtime & Deployment (Firebase App Hosting)
Source of truth: `apphosting.yaml`

- runtime: `nodejs22`
- runCommand: `node build/index.js`

Rules:
- Treat this as a **Node SSR app**, not static.
- Do NOT change runtime, adapter, or runCommand unless explicitly requested.
- Keep Node 22 consistent across:
  - App Hosting runtime
  - Docker (`node:22`)
  - CI

---

## Commands (run from `web/`)
Source of truth: `package.json`

### Development & build
- Dev: `npm run dev` (vite dev)
- Build: `npm run build`
- Preview (prod-like): `npm run preview`

### Quality
- Typecheck: `npm run check` (svelte-check, strict)
- Lint: `npm run lint` (prettier --check + eslint)
- Format: `npm run format`

### Tests
- Unit tests (Vitest): `npm run test:unit`
- E2E tests (Playwright): `npm run test:e2e`
- Full suite: `npm test` (unit + e2e)

### Definition of “done”
Before finishing a task:
1) `npm run check`
2) `npm run lint`
3) `npm run test:unit`
4) `npm run build`
5) `npm run test:e2e` **if** the change affects routing, UI flows, auth, or data

If you skip any step (e.g. E2E), say so explicitly and why.

---

## SvelteKit architecture rules
Source of truth: `svelte.config.js`

- Adapter: `@sveltejs/adapter-node`
- `kit.paths.assets` is `""`

Rules:
- Keep route modules thin (`src/routes/**`).
- Server-only code goes in:
  - `+page.server.ts`
  - `+layout.server.ts`
  - `src/lib/server/**`
- Reusable components: `src/lib/components/**`
- Shared utilities: `src/lib/**`
- Never import server-only code into client components.

---

## TypeScript rules
Source of truth: `tsconfig.json`

- `strict: true`
- `moduleResolution: "bundler"`
- `allowJs: true` + `checkJs: true`

Rules:
- No `any`.
- JS files are type-checked — keep them clean.
- Use ESM-friendly imports.
- Keep filename casing consistent.

---

## Vite & plugins
Source of truth: `vite.config.ts`

Plugins in use:
- `@sveltejs/kit/vite`
- Tailwind
- `vite-plugin-devtools-json`
- Paraglide i18n:
  - project: `./project.inlang`
  - output: `./src/lib/paraglide`

Rules:
- Do not move/rename `project.inlang` or `src/lib/paraglide` without updating config.
- Follow existing Paraglide/i18n patterns when adding strings or routes.

---

## Firebase configuration
Source of truth: `firebase.json`

### Hosting
- `hosting.source`: `.`
- `frameworksBackend.region`: `us-central1`

### Emulators
- apphosting:
  - port: `5002`
  - rootDirectory: `./`
  - startCommand: `npm run dev`
- auth: `9099`
- firestore: `8080`
- UI: enabled
- `singleProjectMode: true`

---

## Firebase emulators (Docker-based) — REQUIRED local workflow
Source of truth:
- `Dockerfile`
- `compose.yaml`
- `emulators.sh`

### How to run
From `web/`:
```bash
docker compose up --build
