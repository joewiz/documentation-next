/**
 * documentation-next: core JavaScript
 *
 * - Syntax highlighting for XQuery code blocks
 * - Keyboard shortcut: "/" to focus search
 * - Category filter state from URL params
 */

function applyHighlighting() {
    // Apply syntax highlighting using CM6/Lezer (same engine as eXide + Notebook)
    const hl = globalThis.highlightCode;
    if (hl) {
        // Standard pre>code blocks (function reference pages)
        document.querySelectorAll("pre code[class*='language-']").forEach((el) => {
            const lang = (el.className.match(/language-(\S+)/) || [])[1];
            if (lang) hl.highlightElement(el, lang);
        });

        // ODD-generated pb-code-highlight elements (article code blocks)
        // Convert to pre>code, then highlight with Lezer
        document.querySelectorAll("pb-code-highlight").forEach((el) => {
            const lang = el.getAttribute("language") || "";
            const pre = document.createElement("pre");
            const code = document.createElement("code");
            code.textContent = el.textContent;
            pre.appendChild(code);
            pre.className = "code-block";
            el.replaceWith(pre);
            if (lang) hl.highlightElement(code, lang);
        });
    }
}

function setup() {
    applyHighlighting();

    // Keyboard shortcut: "/" to focus search input
    document.addEventListener("keydown", (e) => {
        if (
            e.key === "/" &&
            !e.ctrlKey &&
            !e.metaKey &&
            !e.altKey &&
            !["INPUT", "TEXTAREA", "SELECT"].includes(
                document.activeElement.tagName
            )
        ) {
            e.preventDefault();
            const searchInput = document.querySelector(
                '.docs-search input[type="search"], .site-search input[type="search"]'
            );
            if (searchInput) {
                searchInput.focus();
            }
        }
    });

    // Restore category filter from URL params
    const params = new URLSearchParams(window.location.search);
    const category = params.get("category");
    if (category) {
        const select = document.querySelector(
            '.docs-search select[name="category"]'
        );
        if (select) {
            select.value = category;
        }
    }

    // Regenerate button (admin page)
    const regenBtn = document.getElementById("regenerate-btn");
    if (regenBtn) {
        regenBtn.addEventListener("click", async () => {
            const status = document.getElementById("regenerate-status");
            const url = regenBtn.dataset.url;

            regenBtn.disabled = true;
            regenBtn.textContent = "Regenerating...";
            status.textContent = "";

            try {
                const resp = await fetch(url, {
                    method: "POST",
                    credentials: "same-origin",
                });
                const data = await resp.json();

                if (data.status === "ok") {
                    status.textContent =
                        `Done. Generated documentation for ${data.generated} of ${data.total} modules.`;
                    status.className = "status-ok";
                } else {
                    status.textContent = `Error: ${data.message || "Unknown error"}`;
                    status.className = "status-error";
                }
            } catch (err) {
                status.textContent = `Error: ${err.message}`;
                status.className = "status-error";
            } finally {
                regenBtn.disabled = false;
                regenBtn.textContent = "Regenerate";
            }
        });
    }

    // --- Article conversion (admin page) ---

    async function postAction(url, statusEl, btn, originalText) {
        btn.disabled = true;
        btn.textContent = "Working...";
        statusEl.textContent = "";
        try {
            const resp = await fetch(url, { method: "POST", credentials: "same-origin" });
            const data = await resp.json();
            statusEl.textContent = data.summary || data.message || JSON.stringify(data);
            statusEl.className = data.status === "ok" ? "status-ok" : "status-error";
            return data;
        } catch (err) {
            statusEl.textContent = `Error: ${err.message}`;
            statusEl.className = "status-error";
        } finally {
            btn.disabled = false;
            btn.textContent = originalText;
        }
    }

    // Convert All button
    const convertAllBtn = document.getElementById("convert-all-btn");
    if (convertAllBtn) {
        convertAllBtn.addEventListener("click", async () => {
            const status = document.getElementById("convert-status");
            const data = await postAction(
                convertAllBtn.dataset.url, status, convertAllBtn, "Convert All"
            );
            if (data && data.converted) {
                // Update format column for converted articles
                for (const result of data.converted) {
                    if (result.status === "ok") {
                        const row = document.querySelector(
                            `button[data-slug="${result.slug}"]`
                        );
                        if (row) {
                            const tr = row.closest("tr");
                            tr.querySelector("td:nth-child(2)").textContent = "xdita";
                            row.replaceWith(
                                Object.assign(document.createElement("span"),
                                    { className: "badge", textContent: "XDITA" })
                            );
                        }
                    }
                }
            }
        });
    }

    // --- XDITA Editor (admin page) ---
    // Article slug is passed via ?edit=<slug> URL parameter (from "Edit Article" button on article pages)

    const editorEl = document.getElementById("xdita-editor");
    const saveBtn = document.getElementById("save-article-btn");
    const editorStatus = document.getElementById("editor-status");

    if (editorEl) {
        // Derive app base from the current page URL
        const appBase = document.querySelector("link[href*='/resources/css/docs.css']")
            ?.getAttribute("href")?.replace("/resources/css/docs.css", "") || "";

        const editSlug = new URLSearchParams(window.location.search).get("edit");
        if (editSlug) {
            editorStatus.textContent = "Loading...";
            editorEl.setAttribute("url", `${appBase}/api/articles/${editSlug}/xdita`);
            if (saveBtn) saveBtn.disabled = false;
            editorEl.addEventListener("ready", () => {
                editorStatus.textContent = "Loaded.";
            }, { once: true });
        }

        if (saveBtn) {
            saveBtn.addEventListener("click", async () => {
                const slug = new URLSearchParams(window.location.search).get("edit");
                if (!slug) return;
                saveBtn.disabled = true;
                editorStatus.textContent = "Saving...";
                try {
                    const xdita = editorEl.xml;
                    const resp = await fetch(`${appBase}/api/articles/${slug}/xdita`, {
                        method: "PUT",
                        headers: { "Content-Type": "application/xml" },
                        credentials: "same-origin",
                        body: xdita,
                    });
                    const data = await resp.json();
                    editorStatus.textContent = data.status === "ok" ? "Saved." : `Error: ${data.message}`;
                    editorStatus.className = data.status === "ok" ? "status-ok" : "status-error";
                } catch (err) {
                    editorStatus.textContent = `Error: ${err.message}`;
                    editorStatus.className = "status-error";
                } finally {
                    saveBtn.disabled = false;
                }
            });
        }
    }
}

// Run when DOM is ready — guard against DOMContentLoaded already having fired
// (scripts placed at end of body may execute after the event has already fired)
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", setup);
} else {
    setup();
}
