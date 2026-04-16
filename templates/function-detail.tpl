<div class="docs-layout">
    <div class="docs-content">
        <nav class="breadcrumb" aria-label="Breadcrumb">
            [% for $crumb in $breadcrumb?* %]
            [% if exists($crumb?url) %]
            <a href="[[ $crumb?url ]]">[[ $crumb?title ]]</a>
            <span class="breadcrumb-sep" aria-hidden="true">/</span>
            [% else %]
            <span aria-current="page">[[ $crumb?title ]]</span>
            [% endif %]
            [% endfor %]
        </nav>

        <h1>[[ $prefix ]]:[[ $function-name ]]</h1>

        [% for $fn in $functions?* %]
        <section class="[[ $fn?function-class ]]" id="arity-[[ $fn?arity ]]">
            <h2>
                <a class="fn-anchor" href="[[ $app-base ]]/functions/[[ $prefix ]]/[[ $fn?local-name ]]/[[ $fn?arity ]]">#</a>
                [[ $fn?name ]]<span class="fn-arity">#[[ $fn?arity ]]</span>
                [% if $fn?show-deprecated-badge %]
                <span class="badge badge-deprecated">Deprecated</span>
                [% endif %]
            </h2>
            <pre class="signature"><code class="language-xquery">[[ $fn?signature ]]</code></pre>
            <p>[[ $fn?description ]]</p>

            [% if array:size($fn?parameters) > 0 %]
            <h3>Parameters</h3>
            <table class="param-table">
                <thead><tr><th>Name</th><th>Type</th><th>Description</th></tr></thead>
                <tbody>
                    [% for $p in $fn?parameters?* %]
                    <tr>
                        <td class="param-name">[[ $p?name ]]</td>
                        <td class="param-type">[[ $p?type ]][[ $p?occurrence ]]</td>
                        <td>[[ $p?description ]]</td>
                    </tr>
                    [% endfor %]
                </tbody>
            </table>
            [% endif %]

            <h3>Returns</h3>
            <p><code>[[ $fn?return?type ]][[ $fn?return?occurrence ]]</code></p>

            [% if $fn?has-article %]
            <details class="fn-article">
                <summary>More information</summary>
                <div class="fn-article-body">
                    [[ $article-html(string($fn?arity)) ]]
                </div>
            </details>
            [% endif %]

            [% if $has-api %]
            <div class="tryit-section">
                <button class="tryit-btn" data-tryit="[[ $fn?name ]]"
                        data-arity="[[ $fn?arity ]]"
                        data-signature="[[ $fn?signature ]]">Try it</button>
                <div class="tryit-panel" hidden="hidden">
                    <div class="tryit-code-wrapper">
                        [% if $fn?article-query != "" %]
                        <textarea class="tryit-code" rows="8">[[ $fn?article-query ]]</textarea>
                        [% else %]
                        <textarea class="tryit-code" rows="4"></textarea>
                        [% endif %]
                        <button class="tryit-copy" title="Copy to clipboard" aria-label="Copy to clipboard">
                            <svg viewBox="0 0 16 16" width="14" height="14" fill="currentColor"><path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"/><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"/></svg>
                        </button>
                    </div>
                    <button class="tryit-run">Run</button>
                    <pre class="tryit-output"></pre>
                </div>
            </div>
            [% endif %]
        </section>
        [% endfor %]
    </div>
</div>
