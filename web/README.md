# Web App

SvelteKit web app deployed with Firebase App Hosting.

## Runtime

- App Hosting runtime: Node 22 (`apphosting.yaml`)
- Local emulator base image: `ghcr.io/ssenchenko/lass-web-emulator-base:node22-java21`
- Emulator app image: `web/Dockerfile` (installs app deps, uses the base image above)

## Prerequisites

- Docker Desktop (recommended local workflow for Firebase emulators)
- Node.js 22 (only needed for running npm scripts directly on host)

## Local Development (host)

From `web/`:

```sh
npm ci
npm run dev
```

Build:

```sh
npm run build
```

## Firebase Emulators (Docker)

This repository uses Docker as the source of truth for local emulator runs.

From `web/`:

```sh
docker compose up --build
```

The compose file builds `web/Dockerfile` with:

- `FIREBASE_EMULATOR_BASE_IMAGE=ghcr.io/ssenchenko/lass-web-emulator-base:node22-java21`

Override base image (optional):

```sh
FIREBASE_EMULATOR_BASE_IMAGE=ghcr.io/ssenchenko/lass-web-emulator-base:sha-<digest-or-sha> docker compose up --build
```

Expected endpoints:

- App Hosting: [http://127.0.0.1:5002](http://127.0.0.1:5002)
- Auth emulator: [http://127.0.0.1:9099](http://127.0.0.1:9099)
- Firestore emulator: [http://127.0.0.1:8080](http://127.0.0.1:8080)
- Emulator UI: [http://127.0.0.1:4000](http://127.0.0.1:4000)

Stop:

```sh
docker compose down
```

Stop and remove volumes:

```sh
docker compose down -v
```

### Docker hot-swap (file sync)

For fast local iteration without rebuilding the image manually:

```sh
docker compose up --build --watch
```

What hot-swap does in this repo:

- Syncs source file changes into `/app` in the running container
- Ignores `node_modules`, `.svelte-kit`, `build`, `.git`, and `.DS_Store`
- Rebuilds the image automatically when `package.json` or `package-lock.json` changes

### Bootstrap base image locally (optional)

If GHCR base image is not published yet, build and tag it locally:

```sh
docker build -f docker/firebase-emulator-base.Dockerfile -t ghcr.io/ssenchenko/lass-web-emulator-base:node22-java21 .
```

## Test Commands

From `web/`:

```sh
npm run check
npm run lint
npm run test:unit
npm run build
npm run test:e2e
```

## Firebase App Hosting Setup

If App Hosting is not initialized yet in this repo:

```sh
firebase init apphosting
```

This creates `firebase.json` and `.firebaserc`.

If Terraform already manages the backend, import the created backend:

```sh
terraform import google_firebase_app_hosting_backend.default projects/your-project-id/backends/your-backend-id
```
