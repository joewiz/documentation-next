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
                [[ $fn?name ]]#[[ $fn?arity ]]
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
                    [% if $fn?article-query != "" %]
                    <textarea class="tryit-code" rows="8">[[ $fn?article-query ]]</textarea>
                    [% else %]
                    <textarea class="tryit-code" rows="4">[[ $fn?signature ]]</textarea>
                    [% endif %]
                    <button class="tryit-run">Run</button>
                    <pre class="tryit-output"></pre>
                </div>
            </div>
            [% endif %]
        </section>
        [% endfor %]
    </div>
</div>
