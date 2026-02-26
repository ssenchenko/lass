import { paraglideVitePlugin } from "@inlang/paraglide-js";
import devtoolsJson from "vite-plugin-devtools-json";
import tailwindcss from "@tailwindcss/vite";
import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";

export default defineConfig({
  server: {
    // App Hosting emulator sets PORT; local dev still falls back to 5173.
    host: "0.0.0.0",
    port: Number(process.env.PORT) || 5173,
  },
  preview: {
    // App Hosting emulator sets PORT for production-like preview runs in CI.
    host: "0.0.0.0",
    port: Number(process.env.PORT) || 4173,
  },
  plugins: [
    tailwindcss(),
    sveltekit(),
    devtoolsJson(),
    paraglideVitePlugin({
      project: "./project.inlang",
      outdir: "./src/lib/paraglide",
    }),
  ],
  test: {
    expect: { requireAssertions: true },
    projects: [
      {
        extends: "./vite.config.ts",
        test: {
          name: "server",
          environment: "node",
          include: ["src/**/*.{test,spec}.{js,ts}"],
          exclude: ["src/**/*.svelte.{test,spec}.{js,ts}"],
        },
      },
    ],
  },
});
