import { expect, test } from "@playwright/test";

test.beforeAll(async () => {
  const baseURL = process.env.APPHOSTING_EMULATOR_URL ?? "http://127.0.0.1:5002";
  const response = await fetch(baseURL);
  if (!response.ok) {
    throw new Error(
      `App Hosting emulator not ready at ${baseURL}. Make sure emulators are running.`,
    );
  }
});

test("apphosting emulator serves the home page", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("link", { name: "LASS" })).toBeVisible();
  await expect(page.getByRole("heading", { level: 1, name: "Welcome to SvelteKit" })).toBeVisible();
});
