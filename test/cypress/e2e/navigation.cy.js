describe("Navigation and layout", () => {
  it("landing page redirects or shows article index", () => {
    cy.visit("/");
    cy.get(".article-category, .docs-content").should("exist");
  });

  it("keyboard shortcut / focuses search", () => {
    cy.visit("/functions");
    cy.get("body").type("/");
    cy.focused().should("have.attr", "type", "search");
  });

  it("404 page shows for invalid routes", () => {
    cy.visit("/nonexistent-page", { failOnStatusCode: false });
    cy.contains("Page Not Found");
  });

  it("admin page loads", () => {
    cy.visit("/admin");
    cy.contains("Regenerate");
  });

  it("static CSS loads", () => {
    cy.request("/resources/css/docs.css").its("status").should("eq", 200);
  });

  it("static JS loads", () => {
    cy.request("/resources/js/docs.js").its("status").should("eq", 200);
  });

  it("highlight bundle loads", () => {
    cy.request("/resources/js/highlight-bundle.js")
      .its("status")
      .should("eq", 200);
  });
});
