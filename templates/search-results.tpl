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

        <h1>Search</h1>

        <form class="docs-search" action="[[ $app-base ]]/search" method="get">
            <input type="search" name="q" value="[[ $q ]]"
                   placeholder="Search functions and documentation..."
                   aria-label="Search query" autocomplete="off"/>
            <select name="type" aria-label="Filter by type">
                <option value="all">All</option>
                <option value="function">Functions</option>
                <option value="article">Articles</option>
            </select>
            <button type="submit">Search</button>
        </form>

        [% if $q != '' %]
        <p class="search-summary">
            Results for &#8220;<strong>[[ $q ]]</strong>&#8221;
            ([[ array:size($search-results) ]] found:
            [[ $function-count ]] functions, [[ $article-count ]] articles)
        </p>

        [% if array:size($search-results) > 0 %]
        <ol class="search-results">
            [% for $result in $search-results?* %]
            <li class="search-result search-result-[[ $result?type ]]">
                [% if $result?type = 'function' %]
                <h2>
                    <a href="[[ $app-base ]]/functions/[[ $result?prefix ]]/[[ $result?local-name ]]">
                        [[ $result?name ]]#[[ $result?arity ]]
                    </a>
                </h2>
                [% if $result?description != '' %]
                <p class="search-snippet">[[ $result?description ]]</p>
                [% endif %]
                <div class="search-meta">
                    <span class="search-type badge">function</span>
                    <span class="search-module">[[ $result?module-uri ]]</span>
                </div>
                [% else %]
                <h2>
                    <a href="[[ $app-base ]]/articles/[[ $result?slug ]]">
                        [[ $result?title ]]
                    </a>
                </h2>
                [% if $result?description != '' %]
                <p class="search-snippet">[[ $result?description ]]</p>
                [% endif %]
                <div class="search-meta">
                    <span class="search-type badge badge-article">article</span>
                </div>
                [% endif %]
            </li>
            [% endfor %]
        </ol>
        [% else %]
        <p>No results found. Try a different search term.</p>
        [% endif %]

        [% endif %]
    </div>
</div>
