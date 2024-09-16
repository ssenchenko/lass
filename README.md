# Learning Assistant

## Develop

On mac arm there can be a problem running firebase locally. Use docker instead

```bash
# run a container in changes watch-mode
docker compose watch

# alternatevely run as daemon
docker compose up -d

# bring it down
docker compose down
```

Access emulator at http://localhost:4000/

To monitor, access shell of running emulator

```bash
# list running containers
docker container ps

# start bash into container
docker compose exec firebase bash

# see firebase log in docker bash
more firebase-debug.log
```

# create-svelte

Everything you need to build a Svelte project, powered by [`create-svelte`](https://github.com/sveltejs/kit/tree/main/packages/create-svelte).

## Creating a project

If you're seeing this, you've probably already done this step. Congrats!

```bash
# create a new project in the current directory
npm create svelte@latest

# create a new project in my-app
npm create svelte@latest my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://kit.svelte.dev/docs/adapters) for your target environment.
