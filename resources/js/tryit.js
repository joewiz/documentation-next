/**
 * Try-it component for function documentation.
 *
 * Sends XQuery expressions to exist-api's /api/query endpoint
 * and displays results. Degrades gracefully if exist-api is not available.
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

    function handleTryIt(e) {
        const btn = e.currentTarget;
        const panel = btn.closest(".tryit-section")?.querySelector(".tryit-panel")
            || btn.nextElementSibling;

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
            if (codeArea && !codeArea.value.trim()) {
                codeArea.value = generateExample(btn);
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
        const panel = document.createElement("div");
        panel.className = "tryit-panel";
        panel.innerHTML = `
            <textarea class="tryit-code" rows="4">${generateExample(btn)}</textarea>
            <button class="tryit-run">Run</button>
            <pre class="tryit-output" hidden></pre>
        `;
        panel.querySelector(".tryit-run").addEventListener("click", () => {
            runQuery(panel);
        });
        return panel;
    }

    function generateExample(btn) {
        const name = btn.dataset.tryit;
        const signature = btn.dataset.signature || name + "()";
        // Generate a simple call expression from the signature
        return signature.replace(/\$\w+ as [^,)]+/g, "()")
            .replace(/ as .+$/, "");
    }

    async function runQuery(panel) {
        const codeArea = panel.querySelector(".tryit-code");
        const output = panel.querySelector(".tryit-output");
        const runBtn = panel.querySelector(".tryit-run");
        const query = codeArea.value.trim();

        if (!query) return;

        runBtn.disabled = true;
        runBtn.textContent = "Running...";
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
        } catch (err) {
            output.textContent = `Error: ${err.message}`;
        } finally {
            runBtn.disabled = false;
            runBtn.textContent = "Run";
        }
    }
});
