/**
 * Try-it component for function documentation.
 *
 * Sends XQuery expressions to exist-api's /api/eval endpoint
 * and displays results. Degrades gracefully if exist-api is not available.
 *
 * Code input uses <jinn-codemirror mode="xquery"> for syntax highlighting.
 * Result output is highlighted via the highlight-bundle (Lezer/CM6).
 */

document.addEventListener("DOMContentLoaded", () => {
    const API_BASE =
        document.querySelector("html").dataset.apiBase ||
        window.location.pathname.replace(/\/apps\/docs\/.*/, "/apps/exist-api");

    const buttons = document.querySelectorAll("[data-tryit]");
    if (!buttons.length) return;

    // Check if exist-api is available
    checkApiAvailable().then((available) => {
        if (!available) {
            // Hide all try-it buttons
            buttons.forEach((btn) => (btn.style.display = "none"));
            return;
        }

        buttons.forEach((btn) => {
            btn.addEventListener("click", handleTryIt);
            btn.dataset.wired = "1";
        });
    });

    async function checkApiAvailable() {
        try {
            const resp = await fetch(`${API_BASE}/api/system/info`, {
                method: "GET",
                credentials: "same-origin",
            });
            return resp.ok;
        } catch {
            return false;
        }
    }

    /**
     * Read code from a jinn-codemirror element.
     * Falls back to textarea .value for dynamically-created panels
     * before the web component upgrades.
     */
    function readCode(el) {
        return (typeof el.content === "string" ? el.content : el.value) || "";
    }

    /**
     * Write code into a jinn-codemirror element.
     */
    function writeCode(el, code) {
        if (el.tagName === "JINN-CODEMIRROR") {
            el.setAttribute("code", code);
        } else {
            el.value = code;
        }
    }

    /**
     * Force jinn-codemirror to re-render after becoming visible.
     * CM6 can't lay out while the container is hidden, so we poke
     * its internal EditorView to re-measure.
     */
    function refreshEditor(el) {
        if (el._editor) {
            el._editor.requestMeasure();
        }
    }

    function handleTryIt(e) {
        const btn = e.currentTarget;
        const existingPanel = btn.closest(".tryit-section")?.querySelector(".tryit-panel");
        const panel = existingPanel
            || (btn.nextElementSibling?.classList.contains("tryit-panel")
                ? btn.nextElementSibling : null);

        if (!panel) {
            // Create inline panel for module-detail page
            const section = createPanel(btn);
            btn.after(section);
            return;
        }

        // Toggle panel visibility
        if (panel.hidden) {
            panel.hidden = false;
            const codeArea = panel.querySelector(".tryit-code");
            if (codeArea) {
                const existing = readCode(codeArea).trim();
                if (!existing) {
                    writeCode(codeArea, generateExample(btn));
                } else {
                    // Re-set the same code so CM6 re-renders after the panel
                    // becomes visible (it can't lay out while hidden)
                    refreshEditor(codeArea);
                }
            }
            // Wire up Run button if not already done
            const runBtn = panel.querySelector(".tryit-run");
            if (runBtn && !runBtn.dataset.wired) {
                runBtn.dataset.wired = "1";
                runBtn.addEventListener("click", () => runQuery(panel));
            }
        } else {
            panel.hidden = true;
        }
    }

    function createPanel(btn) {
        // Check for pre-populated query: hidden textarea sibling or data attribute
        const querySource = btn.parentElement.querySelector(".tryit-query-source");
        const query = (querySource ? querySource.value : "").trim();
        const code = query || generateExample(btn);
        const panel = document.createElement("div");
        panel.className = "tryit-panel";
        panel.innerHTML = `
            <div class="tryit-code-wrapper">
                <jinn-codemirror class="tryit-code" mode="xquery"></jinn-codemirror>
                <button class="tryit-copy" title="Copy to clipboard" aria-label="Copy to clipboard">
                    <svg viewBox="0 0 16 16" width="14" height="14" fill="currentColor"><path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"/><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"/></svg>
                </button>
            </div>
            <button class="tryit-run">Run</button>
            <pre class="tryit-output" hidden></pre>
        `;
        // Set code after the element is in DOM so the web component can upgrade
        const cm = panel.querySelector(".tryit-code");
        customElements.whenDefined("jinn-codemirror").then(() => {
            writeCode(cm, code);
        });
        panel.querySelector(".tryit-run").addEventListener("click", () => runQuery(panel));
        panel.querySelector(".tryit-copy").addEventListener("click", () => copyCode(panel));
        return panel;
    }

    /** Default placeholder values for XQuery/XSD types */
    const TYPE_DEFAULTS = {
        "xs:string": '"example"',
        "xs:string?": '"example"',
        "xs:string*": '("a", "b", "c")',
        "xs:integer": "42",
        "xs:integer?": "42",
        "xs:int": "42",
        "xs:decimal": "3.14",
        "xs:double": "2.718",
        "xs:float": "1.5",
        "xs:boolean": "true()",
        "xs:boolean?": "true()",
        "xs:date": 'xs:date("2025-01-15")',
        "xs:date?": 'xs:date("2025-01-15")',
        "xs:dateTime": 'current-dateTime()',
        "xs:dateTime?": 'current-dateTime()',
        "xs:time": 'xs:time("14:30:00")',
        "xs:time?": 'xs:time("14:30:00")',
        "xs:duration": 'xs:dayTimeDuration("P1DT2H")',
        "xs:dayTimeDuration": 'xs:dayTimeDuration("PT1H30M")',
        "xs:yearMonthDuration": 'xs:yearMonthDuration("P1Y6M")',
        "xs:anyURI": '"http://example.com"',
        "xs:anyAtomicType": '"foo"',
        "xs:anyAtomicType?": '"foo"',
        "xs:QName": 'xs:QName("fn:concat")',
        "xs:QName?": 'xs:QName("fn:concat")',
        "xs:numeric": "42",
        "node()": "<item>value</item>",
        "node()?": "<item>value</item>",
        "node()*": "(<a/>, <b/>, <c/>)",
        "element()": "<element>text</element>",
        "element()?": "<element>text</element>",
        "element()*": "(<x>1</x>, <y>2</y>)",
        "document-node()": 'doc("/db/apps/docs/data/articles/xmldb/xmldb.xml")',
        "document-node()?": 'doc("/db/apps/docs/data/articles/xmldb/xmldb.xml")',
        "item()": '"hello"',
        "item()?": '"hello"',
        "item()*": '(1, "two", <three/>)',
        "map(*)": 'map { "key": "value" }',
        "map(*)?": 'map { "key": "value" }',
        "array(*)": '["a", "b", "c"]',
        "array(*)?": '["a", "b", "c"]',
        "function(*)": "function($x) { $x }",
        "function(*)?": "function($x) { $x }",
    };

    function defaultForType(type) {
        if (!type) return '"example"';
        const t = type.trim();
        if (TYPE_DEFAULTS[t]) return TYPE_DEFAULTS[t];
        // Handle sequence types like xs:string+ or xs:integer*
        const base = t.replace(/[?*+]$/, "");
        if (TYPE_DEFAULTS[base]) return TYPE_DEFAULTS[base];
        // Fallback
        if (t.startsWith("xs:")) return '"example"';
        if (t.startsWith("map(")) return 'map { "key": "value" }';
        if (t.startsWith("array(")) return '["a", "b"]';
        if (t.startsWith("function(")) return "function($x) { $x }";
        return '"example"';
    }

    /**
     * Generate a runnable XQuery from a function signature.
     * Parses parameters into let clauses with type-appropriate defaults,
     * then returns the function call.
     */
    function generateExample(btn) {
        const name = btn.dataset.tryit;
        const sig = btn.dataset.signature || "";
        if (!sig) return name + "()";

        // Parse parameters from signature: $name as type[occurrence]
        const paramMatch = sig.match(/\(([^)]*)\)/);
        if (!paramMatch || !paramMatch[1].trim()) return name + "()";

        const paramStr = paramMatch[1];
        const params = [];
        let depth = 0, current = "";
        for (const ch of paramStr) {
            if (ch === "(" || ch === "<") depth++;
            else if (ch === ")" || ch === ">") depth--;
            if (ch === "," && depth === 0) {
                params.push(current.trim());
                current = "";
            } else {
                current += ch;
            }
        }
        if (current.trim()) params.push(current.trim());

        const lets = [];
        const args = [];
        for (const p of params) {
            const m = p.match(/^\$(\S+)\s+as\s+(.+)$/);
            if (m) {
                const varName = m[1];
                const type = m[2].trim();
                lets.push(`let $${varName} := ${defaultForType(type)}`);
                args.push("$" + varName);
            } else {
                // Bare parameter without type
                const vm = p.match(/^\$(\S+)/);
                if (vm) {
                    lets.push(`let $${vm[1]} := "example"`);
                    args.push("$" + vm[1]);
                }
            }
        }

        if (lets.length === 0) return name + "()";

        return lets.join("\n") + "\nreturn\n    " + name + "(" + args.join(", ") + ")";
    }

    function copyCode(panel) {
        const codeArea = panel.querySelector(".tryit-code");
        const copyBtn = panel.querySelector(".tryit-copy");
        if (!codeArea || !copyBtn) return;
        navigator.clipboard.writeText(readCode(codeArea)).then(() => {
            copyBtn.classList.add("copied");
            setTimeout(() => copyBtn.classList.remove("copied"), 1500);
        });
    }

    /**
     * Highlight the try-it output element based on content type.
     * XML → xml, JSON-like → json, atomic values → no highlighting.
     */
    function highlightOutput(output) {
        const hl = globalThis.highlightCode;
        if (!hl) return;
        const text = output.textContent;
        const type = /^\s*</.test(text) ? "xml"
                   : /^\s*[\[{]/.test(text) ? "json"
                   : null;
        if (type) {
            hl.highlightElement(output, type);
        }
    }

    async function runQuery(panel) {
        const codeArea = panel.querySelector(".tryit-code");
        const output = panel.querySelector(".tryit-output");
        const runBtn = panel.querySelector(".tryit-run");
        const query = readCode(codeArea).trim();

        if (!query) return;

        runBtn.disabled = true;
        runBtn.textContent = "Running...";
        output.hidden = false;
        output.textContent = "Executing...";

        try {
            const resp = await fetch(`${API_BASE}/api/eval`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                credentials: "same-origin",
                body: JSON.stringify({
                    query,
                    count: 50,
                    method: "adaptive",
                    indent: "yes",
                    "omit-xml-declaration": "yes",
                }),
            });

            const text = await resp.text();
            output.textContent = text || "(empty result)";
            highlightOutput(output);
        } catch (err) {
            output.textContent = `Error: ${err.message}`;
        } finally {
            runBtn.disabled = false;
            runBtn.textContent = "Run";
        }
    }
});
