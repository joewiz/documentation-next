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
    cy.get(".function-variant").should("have.length.greaterThan", 0);
  });

  it("function signatures have code highlighting", () => {
    cy.visit("/functions/fn/");
    cy.get(".signature code").should("have.length.greaterThan", 0);
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
