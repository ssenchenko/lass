import { defineConfig, devices } from '@playwright/test';

const baseURL = process.env.APPHOSTING_EMULATOR_URL ?? 'http://127.0.0.1:5002';

export default defineConfig({
	testDir: 'e2e',
	testMatch: 'apphosting.emulator.test.ts',
	use: {
		baseURL,
		trace: 'retain-on-failure',
		screenshot: 'only-on-failure',
		video: 'retain-on-failure'
	},
	projects: [
		{
			name: 'chromium',
			use: { ...devices['Desktop Chrome'] }
		}
	]
});
