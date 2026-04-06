import { defineConfig } from "cypress";

export default defineConfig({
  fixturesFolder: "test/cypress/fixtures",
  screenshotsFolder: "test/cypress/screenshots",
  videosFolder: "test/cypress/videos",
  e2e: {
    baseUrl: "http://localhost:8080/exist/apps/docs/",
    pageLoadTimeout: 60000,
    responseTimeout: 60000,
    specPattern: "test/cypress/e2e/**/*.cy.{js,ts}",
    supportFile: false,
  },
});
