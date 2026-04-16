/**
 * Try-it widget tests.
 *
 * Assumes exist-api is installed (it is a declared dependency).
 * Uses fn:substring as the test target because it has exactly 2 arity variants.
 */
describe("Try-it widget", () => {
  const FUNC_URL = "/functions/fn/substring";

  beforeEach(() => {
    cy.visit(FUNC_URL);
  });

  it("tryit.js loads successfully", () => {
    cy.request("/resources/js/tryit.js").its("status").should("eq", 200);
  });

  it("Try it buttons are present on function detail page", () => {
    cy.get(".tryit-btn[data-wired]").should("have.length.greaterThan", 0);
  });

  it("Try it panel is hidden before clicking", () => {
    cy.get(".tryit-panel").first().should("have.attr", "hidden");
  });

  it("clicking Try it reveals the panel", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().should("not.have.attr", "hidden");
  });

  it("panel textarea is pre-populated with a query after opening", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first()
      .find(".tryit-code")
      .invoke("val")
      .should("not.be.empty");
  });

  it("user can edit the query in the textarea", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().find(".tryit-code")
      .clear()
      .type("1 to 5");
    cy.get(".tryit-panel").first()
      .find(".tryit-code")
      .should("have.value", "1 to 5");
  });

  it("clicking Run executes query and shows output", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().find(".tryit-code")
      .clear()
      .type("1 to 5");
    cy.get(".tryit-panel").first().find(".tryit-run").click();
    // Wait for output to contain text (set synchronously to "Executing..." then results)
    cy.get(".tryit-panel").first()
      .find(".tryit-output")
      .should("not.be.empty");
  });

  it("Run button returns to enabled state after execution", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().find(".tryit-code")
      .clear()
      .type("1 to 3");
    cy.get(".tryit-panel").first().find(".tryit-run").click();
    cy.get(".tryit-panel").first()
      .find(".tryit-run", { timeout: 10000 })
      .should("not.be.disabled")
      .and("have.text", "Run");
  });

  it("clicking Try it again hides the panel", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().should("not.have.attr", "hidden");
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().should("have.attr", "hidden");
  });

  it("XQuery error in query shows error message in output", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().find(".tryit-code")
      .clear()
      .type("this is not valid xquery !!!");
    cy.get(".tryit-panel").first().find(".tryit-run").click();
    cy.get(".tryit-panel").first()
      .find(".tryit-output", { timeout: 10000 })
      .invoke("text")
      .should("include", "Error");
  });

  it("fn:substring has two arity variants with separate Try it buttons", () => {
    cy.get(".tryit-btn[data-wired]").should("have.length", 2);
  });

  it("each arity variant's panel opens independently", () => {
    // Open second variant — first should stay closed
    cy.get(".tryit-btn[data-wired]").eq(1).click();
    cy.get(".tryit-panel").eq(0).should("have.attr", "hidden");
    cy.get(".tryit-panel").eq(1).should("not.have.attr", "hidden");
  });
});
