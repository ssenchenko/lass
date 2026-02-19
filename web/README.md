# Web App

SvelteKit web app deployed with Firebase App Hosting.

## Runtime

- App Hosting runtime: Node 22 (`apphosting.yaml`)
- Local emulator container base image: `node:22`
- Java 21 is installed inside the emulator container for Firebase emulators

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
