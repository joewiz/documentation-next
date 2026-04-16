describe("Function reference", () => {
  it("module browser loads with categories", () => {
    cy.visit("/functions/");
    cy.get(".module-category").should("have.length.greaterThan", 0);
    cy.get(".module-card").should("have.length.greaterThan", 0);
  });

  it("module detail shows functions", () => {
    cy.visit("/functions/fn/");
    cy.get(".function").should("have.length.greaterThan", 0);
    cy.get(".signature").should("have.length.greaterThan", 0);
  });

  it("function detail page loads", () => {
    cy.visit("/functions/fn/concat");
    cy.get(".function").should("have.length.greaterThan", 0);
  });

  it("function signatures have Lezer syntax highlighting tokens", () => {
    cy.visit("/functions/fn/concat");
    // Lezer injects tok-* spans into the code element after page load
    cy.get(".signature code [class^='tok-']").should("have.length.greaterThan", 0);
  });

  it("param-name variable color matches signature tok-variableName color", () => {
    cy.visit("/functions/fn/concat");
    // Both should use the same brown (#953800) from the GitHub Light token theme
    cy.get(".param-name").first()
      .should("have.css", "color", "rgb(149, 56, 0)");
  });

  it("function detail has parameter table", () => {
    cy.visit("/functions/fn/concat");
    cy.get(".param-table").should("exist");
  });

  it("function detail shows return type", () => {
    cy.visit("/functions/fn/concat");
    cy.get("h3").should("contain.text", "Returns");
  });

  it("breadcrumb navigates back to module list", () => {
    cy.visit("/functions/fn/concat");
    cy.get(".breadcrumb a").contains("Functions").click();
    cy.url().should("include", "/functions/");
  });

  it("module card links to module detail", () => {
    cy.visit("/functions/");
    cy.get(".module-card a").first().click();
    cy.get(".module-header, .function").should("exist");
  });
});
