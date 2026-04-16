describe("Unified search", () => {
  it("search page loads", () => {
    cy.visit("/search");
    cy.get(".docs-search").should("exist");
    cy.get('input[name="q"]').should("exist");
  });

  it("search returns results for a common term", () => {
    cy.visit("/search?q=store");
    cy.get(".search-result").should("have.length.greaterThan", 0);
    cy.get(".search-summary").should("contain.text", "results for");
  });

  it("search results include type badges", () => {
    cy.visit("/search?q=store");
    cy.get(".search-type").should("have.length.greaterThan", 0);
  });

  it("search with no results shows message", () => {
    cy.visit("/search?q=xyznonexistentterm123");
    cy.contains("No results found");
  });

  it("search form submits and shows results", () => {
    cy.visit("/search");
    cy.get(".docs-search input[name='q']").type("xmldb");
    cy.get(".docs-search button[type='submit']").click();
    cy.get(".search-summary").should("exist");
  });

  it("type facets are present on results page", () => {
    cy.visit("/search?q=store");
    cy.get(".facet-group").should("have.length.greaterThan", 0);
    cy.get(".facet-link").should("have.length.greaterThan", 0);
  });

  it("function results link to function detail", () => {
    cy.visit("/search?q=concat");
    cy.get(".search-result-function a").first().should("have.attr", "href")
      .and("include", "/functions/");
  });

  it("article results link to article detail", () => {
    cy.visit("/search?q=docker");
    cy.get(".search-result-article a").first().should("have.attr", "href")
      .and("include", "/articles/");
  });
});
