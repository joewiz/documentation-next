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

  it("panel code input uses jinn-codemirror with XQuery mode", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first()
      .find("jinn-codemirror.tryit-code")
      .should("exist")
      .and("have.attr", "mode", "xquery");
  });

  it("jinn-codemirror initializes with CodeMirror editor", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel jinn-codemirror", { timeout: 5000 })
      .shadow()
      .find(".cm-editor")
      .should("exist");
  });

  it("clicking Run executes query and shows output", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
    cy.get(".tryit-panel").first().find(".tryit-run").click();
    // Wait for output to appear (set synchronously to "Executing..." then results)
    cy.get(".tryit-panel").first()
      .find(".tryit-output", { timeout: 10000 })
      .should("not.be.empty")
      .and("not.contain", "Executing...");
  });

  it("Run button returns to enabled state after execution", () => {
    cy.get(".tryit-btn[data-wired]").first().click();
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

  it("fn:substring has two arity variants with separate Try it buttons", () => {
    cy.get(".tryit-btn[data-wired]").should("have.length", 2);
  });

  it("each arity variant's panel opens independently", () => {
    // Open second variant — first should stay closed
    cy.get(".tryit-btn[data-wired]").eq(1).click();
    cy.get(".tryit-panel").eq(0).should("have.attr", "hidden");
    cy.get(".tryit-panel").eq(1).should("not.have.attr", "hidden");
  });

  it("function signature has syntax highlighting", () => {
    cy.get("code.language-xquery").first().within(() => {
      cy.get(".tok-keyword, .tok-variableName, .tok-typeName, .tok-punctuation")
        .should("have.length.greaterThan", 0);
    });
  });
});

describe("Try-it output syntax highlighting", () => {
  it("XML output has syntax highlighting", () => {
    cy.visit("/functions/fn/substring");
    cy.get(".tryit-btn[data-wired]", { timeout: 5000 }).first().click();

    // Wait for jinn-codemirror to initialize, then set a query that returns XML
    cy.get(".tryit-section").first().find("jinn-codemirror", { timeout: 5000 }).then(($cm) => {
      $cm[0].value = '<root><child attr="val">text</child></root>';
    });

    cy.get(".tryit-section").first().find(".tryit-run").click();

    // Wait for run to complete, then check for highlighted output
    cy.get(".tryit-section").first().find(".tryit-run", { timeout: 10000 })
      .should("have.text", "Run");

    // XML output should have tok-* highlighted spans
    cy.get(".tryit-section").first().find(".tryit-output span[class^='tok-']")
      .should("exist");
  });

  it("atomic text output does NOT have syntax highlighting", () => {
    cy.visit("/functions/fn/substring");
    cy.get(".tryit-btn[data-wired]", { timeout: 5000 }).first().click();
    cy.get(".tryit-panel .tryit-run").first().click();

    cy.get(".tryit-output", { timeout: 10000 })
      .should("not.contain", "Executing...");

    // Atomic string result — should NOT have tok-* spans
    cy.get(".tryit-output .tok-tagName").should("not.exist");
  });
});
