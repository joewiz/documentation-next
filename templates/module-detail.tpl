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

        [% if array:size($modules) > 1 %]
        <div class="disambiguation">
            <h1>Multiple modules with prefix [[ $prefix ]]</h1>
            <p>Select the module you are looking for:</p>
            <ul>
                [% for $m in $modules?* %]
                <li>
                    <a href="[[ $app-base ]]/functions/view?uri=[[ encode-for-uri($m?uri) ]]">
                        [[ $m?uri ]]
                    </a>
                </li>
                [% endfor %]
            </ul>
        </div>
        [% else %]

        <header class="module-header">
            <h1>[[ $module?prefix ]] Module</h1>
            <p class="module-uri">[[ $module?uri ]]</p>
        </header>

        <div class="docs-article-layout">
            <div class="function-list">
                [% for $fn in $module?functions?* %]
                <div class="[[ $fn?function-class ]]" id="[[ $fn?local-name ]].[[ $fn?arity ]]">
                    <h3>
                        <a class="fn-anchor" href="#[[ $fn?local-name ]].[[ $fn?arity ]]">#</a>
                        <a href="[[ $app-base ]]/functions/[[ $prefix ]]/[[ $fn?local-name ]]">[[ $fn?name ]]</a><span class="fn-arity">#[[ $fn?arity ]]</span>
                        [% if $fn?show-deprecated-badge %]
                        <span class="badge badge-deprecated">Deprecated</span>
                        [% endif %]
                        [% if $fn?has-article %]
                        <a class="fn-article-badge" href="[[ $app-base ]]/functions/[[ $prefix ]]/[[ $fn?local-name ]]">more</a>
                        [% endif %]
                    </h3>
                    <pre class="signature"><code class="language-xquery">[[ $fn?signature ]]</code></pre>
                    <p>[[ $fn?description ]]</p>

                    [% if array:size($fn?parameters) > 0 %]
                    <table class="param-table">
                        <thead><tr><th>Parameter</th><th>Type</th><th>Description</th></tr></thead>
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

                    <div class="return-type">
                        <strong>Returns:</strong> <code>[[ $fn?return?type ]][[ $fn?return?occurrence ]]</code>
                    </div>

                    [% if $has-api %]
                    <button class="tryit-btn" data-tryit="[[ $fn?name ]]"
                            data-arity="[[ $fn?arity ]]"
                            data-signature="[[ $fn?signature ]]">Try it</button>
                    [% endif %]
                </div>
                [% endfor %]
            </div>

            <aside class="docs-sidebar">
                <nav class="toc module-toc" aria-label="Function list">
                    <h3>Functions</h3>
                    <ul>
                        [% for $fn in $module?functions?* %]
                        <li>
                            <a href="#[[ $fn?local-name ]].[[ $fn?arity ]]">[[ $fn?local-name ]]#[[ $fn?arity ]]</a>
                        </li>
                        [% endfor %]
                    </ul>
                </nav>
            </aside>
        </div>

        [% endif %]
    </div>
</div>
