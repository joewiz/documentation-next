<div class="docs-layout">
    <div class="docs-content">
        <header class="docs-header">
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

            <h1>XQuery Function Reference</h1>
            <p class="lead">Browse and search all XQuery functions available in eXist-db.</p>
        </header>

        <form class="docs-search" action="[[ $app-base ]]/search" method="get">
            <input type="search" name="q" value="[[ $q ]]"
                   placeholder="Search functions..." aria-label="Search functions"
                   autocomplete="off"/>
            <select name="category" aria-label="Filter by category">
                <option value="all">All Categories</option>
                <option value="w3c">W3C Functions</option>
                <option value="extension">Extensions</option>
                <option value="application">Application</option>
            </select>
            <button type="submit">Search</button>
        </form>

        [% for $cat in $categories?* %]
        <section class="module-category" id="category-[[ $cat?id ]]">
            <h2>[[ $cat?title ]]</h2>
            <div class="module-grid">
                [% for $mod in $cat?modules?* %]
                <div class="module-card">
                    <h3>
                        <a href="[[ $app-base ]]/functions/[[ $mod?prefix ]]">
                            [[ $mod?prefix ]]
                        </a>
                    </h3>
                    <p class="module-uri">[[ $mod?uri ]]</p>
                    [% if $mod?description != '' %]
                    <p class="module-description">[[ $mod?description ]]</p>
                    [% endif %]
                    <span class="badge">[[ $mod?function-count ]] functions</span>
                </div>
                [% endfor %]
            </div>
        </section>
        [% endfor %]
    </div>
</div>
