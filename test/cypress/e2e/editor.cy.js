/**
 * Cypress tests for the jinn-tap XDITA editor.
 *
 * Requires:
 *   - eXist-db running at http://localhost:8080
 *   - docs app installed with at least the "xmldb" article
 *   - logged in as admin (or the admin credentials set in cypress.config.js)
 *
 * The editor is accessed via /admin?edit=<slug>.
 * jinn-tap loads XDITA XML from /api/articles/<slug>/xdita and renders it.
 */

const ADMIN_URL = "/admin?edit=xmldb";
const LOGIN_URL = "http://localhost:8080/exist/apps/docs/login";

// Log in before editor tests — editor requires authentication
before(() => {
  cy.request({
    method: "POST",
    url: LOGIN_URL,
    form: true,
    body: { user: "admin", password: "" },
    followRedirect: false,
  });
});

describe("jinn-tap editor — page load", () => {
  beforeEach(() => {
    cy.visit(ADMIN_URL);
  });

  it("admin page loads with edit param", () => {
    cy.url().should("include", "edit=xmldb");
    cy.get("h1").should("contain.text", "Documentation Administration");
  });

  it("jinn-tap web component is present", () => {
    cy.get("#xdita-editor").should("exist");
  });

  it("editor container is visible", () => {
    cy.get("#editor-container").should("be.visible");
  });

  it("Save button is present and enabled when slug provided", () => {
    cy.get("#save-article-btn").should("exist").and("not.be.disabled");
  });

  it("editor status transitions from Loading to Loaded", () => {
    cy.get("#editor-status").should("contain.text", "Loading");
    cy.get("#editor-status", { timeout: 15000 }).should("contain.text", "Loaded");
  });
});

describe("jinn-tap editor — XDITA content rendering", () => {
  beforeEach(() => {
    cy.visit(ADMIN_URL);
    // Wait for editor to finish loading
    cy.get("#editor-status", { timeout: 15000 }).should("contain.text", "Loaded");
  });

  it("editor shadow DOM or content area has rendered content", () => {
    // The ProseMirror editor div is rendered inside the jinn-tap shadow DOM
    // We verify the custom element has content (non-zero height)
    cy.get("#xdita-editor").then(($el) => {
      const height = $el[0].getBoundingClientRect().height;
      expect(height).to.be.greaterThan(50);
    });
  });

  it("no fatal SyntaxError in schema (graphic/group errors produce blank editor)", () => {
    // If schema has fatal errors, jinn-tap renders nothing; content height is ~0
    cy.get("#xdita-editor").then(($el) => {
      const height = $el[0].getBoundingClientRect().height;
      expect(height).to.be.greaterThan(100);
    });
  });

  it("ProseMirror editor is initialized inside jinn-tap", () => {
    // jinn-tap uses light DOM (no shadow DOM)
    cy.get("#xdita-editor").find(".ProseMirror").should("exist");
  });

  it("editor contains rendered paragraph content (not blank)", () => {
    cy.get("#xdita-editor")
      .find(".ProseMirror tei-p")
      .should("have.length.greaterThan", 0);
  });

  it("editor contains section headings", () => {
    cy.get("#xdita-editor")
      .find(".ProseMirror")
      .should("contain.text", "Manipulating Database Contents");
  });

  it("editor contains list items with text content (not blank bullets)", () => {
    cy.get("#xdita-editor")
      .find(".ProseMirror tei-li")
      .first()
      .should("not.be.empty")
      .invoke("text")
      .should("have.length.greaterThan", 10);
  });

  it("editor list items all have non-empty text content", () => {
    cy.get("#xdita-editor")
      .find(".ProseMirror tei-li")
      .each(($li) => {
        cy.wrap($li).invoke("text").should("have.length.greaterThan", 0);
      });
  });
});

describe("jinn-tap editor — API", () => {
  it("XDITA API endpoint returns XML for xmldb article", () => {
    cy.request({
      url: "/api/articles/xmldb/xdita",
      headers: { Accept: "application/xml" },
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.headers["content-type"]).to.include("xml");
      expect(response.body).to.include("<topic");
    });
  });

  it("XDITA XML has expected structure", () => {
    cy.request("/api/articles/xmldb/xdita").then((response) => {
      expect(response.body).to.include("<body");
      expect(response.body).to.include("<section");
      expect(response.body).to.include("<ul");
      expect(response.body).to.include("<li");
    });
  });
});

describe("jinn-tap editor — edit button on article pages", () => {
  it("article page has Edit Article button when logged in", () => {
    cy.visit("/articles/xmldb");
    // Edit button is only shown when logged in — assumes admin session
    cy.get(".article-actions a").should("exist").and("contain.text", "Edit Article");
  });

  it("Edit Article button links to admin?edit=<slug>", () => {
    cy.visit("/articles/xmldb");
    cy.get(".article-actions a")
      .should("have.attr", "href")
      .and("include", "admin")
      .and("include", "edit=xmldb");
  });

  it("Edit Article button navigates to editor with correct slug", () => {
    cy.visit("/articles/xmldb");
    cy.get(".article-actions a").click();
    cy.url().should("include", "edit=xmldb");
    cy.get("#xdita-editor").should("exist");
  });
});
