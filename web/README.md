# sv

Everything you need to build a Svelte project, powered by [`sv`](https://github.com/sveltejs/cli).

## Creating a project

If you're seeing this, you've probably already done this step. Congrats!

```sh
# create a new project in the current directory
npx sv create

# create a new project in my-app
npx sv create my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```sh
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```sh
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.

## Firebase App Hosting Setup

This project uses Firebase App Hosting for deployment. The initial setup is done using the Firebase CLI.

1.  **Install the Firebase CLI:**

    ```sh
    npm install -g firebase-tools
    ```

2.  **Login to Firebase:**

    ```sh
    firebase login
    ```

3.  **Initialize Firebase App Hosting:**

    Run the following command in the `web` directory:

    ```sh
    firebase init apphosting
    ```

    This will guide you through the following steps:

    *   Select a Firebase project.
    *   Connect to a GitHub repository.
    *   Configure the build settings (the CLI should automatically detect the SvelteKit settings).

    This will create a `firebase.json` file and a `.firebaserc` file.

4.  **Update Terraform:**

    The `firebase init apphosting` command will create a `google_firebase_app_hosting_backend` resource. You will need to import this resource into your Terraform state.

    ```sh
    terraform import google_firebase_app_hosting_backend.default projects/your-project-id/backends/your-backend-id
    ```
