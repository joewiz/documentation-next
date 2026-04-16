/**
 * documentation-next: core JavaScript
 *
 * - Syntax highlighting for XQuery code blocks
 * - Keyboard shortcut: "/" to focus search
 * - Category filter state from URL params
 */

/**
 * Wrap a <pre> element in a .code-block-wrapper div and add a copy button.
 */
function wrapWithCopyButton(pre) {
    const wrapper = document.createElement("div");
    wrapper.className = "code-block-wrapper";

    const btn = document.createElement("button");
    btn.className = "code-copy-btn";
    btn.title = "Copy code";
    btn.textContent = "Copy";
    btn.addEventListener("click", () => {
        const text = pre.textContent;
        navigator.clipboard.writeText(text).then(() => {
            btn.textContent = "Copied!";
            btn.classList.add("copied");
            setTimeout(() => {
                btn.textContent = "Copy";
                btn.classList.remove("copied");
            }, 1500);
        });
    });

    pre.parentNode.insertBefore(wrapper, pre);
    wrapper.appendChild(pre);
    wrapper.appendChild(btn);
}

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
            wrapWithCopyButton(pre);
        });
    }

    // Add copy buttons to any pre.code-block elements already in the DOM
    // (e.g. function reference pages with pre>code.language-*)
    document.querySelectorAll("pre.code-block:not(.code-block-wrapper > pre)").forEach((pre) => {
        wrapWithCopyButton(pre);
    });
}

/**
 * Normalize text for heading ↔ TOC link matching.
 */
function normalizeText(s) {
    return s.replace(/\s+/g, " ").trim().toLowerCase();
}

/**
 * Slug a heading text to use as an id.
 */
function slugify(s) {
    return s.trim().toLowerCase()
        .replace(/[^\w\s-]/g, "")
        .replace(/\s+/g, "-")
        .replace(/-+/g, "-");
}

/**
 * TOC active-section highlighting via IntersectionObserver.
 *
 * XDITA renders headings without id attributes, so we:
 *  1. Pair each TOC link to an article heading by normalised text.
 *  2. Assign a slug-id to the heading and update the TOC href.
 *  3. Observe each paired heading and highlight the topmost visible one.
 */
function setupTOC() {
    const toc = document.querySelector(".toc");
    if (!toc) return;

    const article = document.querySelector(".xdita-article");
    if (!article) return;

    // All article headings in document order
    const articleHeadings = Array.from(article.querySelectorAll("h1, h2, h3, h4, h5, h6"));

    // All TOC anchor links
    const tocLinks = Array.from(toc.querySelectorAll("a[href]"));

    if (articleHeadings.length === 0 || tocLinks.length === 0) return;

    // Build a map: normalised link text → first unmatched heading element
    const textToHeading = new Map();
    articleHeadings.forEach((h) => {
        const key = normalizeText(h.textContent);
        if (!textToHeading.has(key)) textToHeading.set(key, h);
    });

    // Pair TOC links to headings; assign ids
    const seen = {};
    const pairs = []; // { a, h }
    tocLinks.forEach((a) => {
        const key = normalizeText(a.textContent);
        const h = textToHeading.get(key);
        if (!h) return;

        if (!h.id) {
            let base = slugify(a.textContent);
            let id = base;
            let n = 1;
            while (seen[id]) { id = base + "-" + (++n); }
            h.id = id;
        }
        seen[h.id] = true;
        a.href = "#" + h.id;
        pairs.push({ a, h });
    });

    if (pairs.length === 0) return;

    const visible = new Set();
    const headingList = pairs.map((p) => p.h);
    const linkMap = new Map(pairs.map((p) => [p.h.id, p.a]));

    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) visible.add(entry.target.id);
                else visible.delete(entry.target.id);
            });

            let activated = false;
            headingList.forEach((h) => {
                const a = linkMap.get(h.id);
                if (!a) return;
                if (!activated && visible.has(h.id)) {
                    a.classList.add("toc-active");
                    activated = true;
                } else {
                    a.classList.remove("toc-active");
                }
            });

            if (!activated) {
                const scrollY = window.scrollY;
                let last = null;
                headingList.forEach((h) => {
                    if (h.getBoundingClientRect().top + window.scrollY <= scrollY + 80) last = h;
                });
                if (last) {
                    pairs.forEach(({ a }) => a.classList.remove("toc-active"));
                    const a = linkMap.get(last.id);
                    if (a) a.classList.add("toc-active");
                }
            }
        },
        { rootMargin: "0px 0px -55% 0px", threshold: 0 }
    );

    headingList.forEach((h) => observer.observe(h));
}

/**
 * Heading anchor links: show a copy-link icon on hover, copy fragment URL to clipboard.
 */
function setupHeadingAnchors() {
    const article = document.querySelector(".xdita-article, .docs-content article");
    if (!article) return;

    // Assign ids to any headings that setupTOC didn't already cover
    const seen = {};
    article.querySelectorAll("h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]").forEach((h) => { seen[h.id] = true; });
    article.querySelectorAll("h1:not([id]), h2:not([id]), h3:not([id]), h4:not([id]), h5:not([id]), h6:not([id])").forEach((h) => {
        let base = h.textContent.trim().toLowerCase().replace(/[^\w\s-]/g, "").replace(/\s+/g, "-").replace(/-+/g, "-");
        let id = base;
        let n = 1;
        while (seen[id]) { id = base + "-" + (++n); }
        h.id = id;
        seen[id] = true;
    });

    article.querySelectorAll("h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]").forEach((h) => {
        const btn = document.createElement("button");
        btn.className = "heading-anchor-btn";
        btn.title = "Copy link to this section";
        btn.setAttribute("aria-label", "Copy link to this section");
        btn.innerHTML = '<svg viewBox="0 0 16 16" width="14" height="14" fill="currentColor"><path d="M7.775 3.275a.75.75 0 0 0 1.06 1.06l1.25-1.25a2 2 0 1 1 2.83 2.83l-2.5 2.5a2 2 0 0 1-2.83 0 .75.75 0 0 0-1.06 1.06 3.5 3.5 0 0 0 4.95 0l2.5-2.5a3.5 3.5 0 0 0-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 0 1 0-2.83l2.5-2.5a2 2 0 0 1 2.83 0 .75.75 0 0 0 1.06-1.06 3.5 3.5 0 0 0-4.95 0l-2.5 2.5a3.5 3.5 0 0 0 4.95 4.95l1.25-1.25a.75.75 0 0 0-1.06-1.06l-1.25 1.25a2 2 0 0 1-2.83 0z"/></svg>';
        btn.addEventListener("click", () => {
            const url = location.origin + location.pathname + "#" + h.id;
            navigator.clipboard.writeText(url).then(() => {
                btn.classList.add("copied");
                setTimeout(() => btn.classList.remove("copied"), 1500);
            });
        });
        h.appendChild(btn);
    });
}

function setup() {
    applyHighlighting();
    setupTOC();
    setupHeadingAnchors();

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
