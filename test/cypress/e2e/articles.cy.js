describe("Article browsing", () => {
  it("article index loads with categories", () => {
    cy.visit("/articles/");
    cy.get(".article-category").should("have.length.greaterThan", 0);
    cy.get(".article-item").should("have.length.greaterThan", 0);
  });

  it("article detail renders content", () => {
    cy.visit("/articles/docker");
    cy.get(".xdita-article").should("exist");
    cy.get("h1").should("contain.text", "Docker");
  });

  it("article has table of contents", () => {
    cy.visit("/articles/docker");
    cy.get(".toc").should("exist");
    cy.get(".toc a").should("have.length.greaterThan", 0);
  });

  it("TOC links navigate to sections", () => {
    cy.visit("/articles/configuration");
    cy.get(".toc a").first().click();
    cy.url().should("include", "#");
  });

  it("breadcrumb shows article path", () => {
    cy.visit("/articles/docker");
    cy.get(".breadcrumb").should("exist");
    cy.get(".breadcrumb").should("contain.text", "Articles");
  });

  it("code blocks are present in article", () => {
    cy.visit("/articles/docker");
    cy.get(".xdita-article code").should("have.length.greaterThan", 0);
  });
});
