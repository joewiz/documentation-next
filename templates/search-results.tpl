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
            <button type="submit">Search</button>
        </form>

        [% if $q != '' %]
        <p class="search-summary">
            [[ array:size($search-results) ]] result[[ if (array:size($search-results) != 1) then 's' else '' ]] for &#8220;<strong>[[ $q ]]</strong>&#8221;
        </p>

        <div class="search-layout">

            <aside class="search-facets">

                <div class="facet-group">
                    <h3 class="facet-heading">Type</h3>
                    <ul class="facet-list">
                        <li>
                            [% if $type-filter = 'all' and $prefix-filter = '' %]
                            <span class="facet-link facet-active">All <span class="facet-count">([[ $function-count + $article-count ]])</span></span>
                            [% else %]
                            <a class="facet-link" href="[[ $app-base ]]/search?q=[[ encode-for-uri($q) ]]&amp;type=all">All <span class="facet-count">([[ $function-count + $article-count ]])</span></a>
                            [% endif %]
                        </li>
                        <li>
                            [% if $type-filter = 'function' and $prefix-filter = '' %]
                            <span class="facet-link facet-active">Functions <span class="facet-count">([[ $function-count ]])</span></span>
                            [% else %]
                            <a class="facet-link" href="[[ $app-base ]]/search?q=[[ encode-for-uri($q) ]]&amp;type=function">Functions <span class="facet-count">([[ $function-count ]])</span></a>
                            [% endif %]
                        </li>
                        <li>
                            [% if $type-filter = 'article' %]
                            <span class="facet-link facet-active">Articles <span class="facet-count">([[ $article-count ]])</span></span>
                            [% else %]
                            <a class="facet-link" href="[[ $app-base ]]/search?q=[[ encode-for-uri($q) ]]&amp;type=article">Articles <span class="facet-count">([[ $article-count ]])</span></a>
                            [% endif %]
                        </li>
                    </ul>
                </div>

                [% if ($type-filter = 'function' or $type-filter = 'all') and map:size($category-facets) > 0 %]
                <div class="facet-group">
                    <h3 class="facet-heading">Module Category</h3>
                    <ul class="facet-list">
                        [% for $cat in (for $k in map:keys($category-facets) order by $category-facets($k) descending return $k) %]
                        <li>
                            [% if $category-filter = $cat %]
                            <span class="facet-link facet-active">[[ $cat ]] <span class="facet-count">([[ $category-facets($cat) ]])</span></span>
                            [% else %]
                            <a class="facet-link" href="[[ $app-base ]]/search?q=[[ encode-for-uri($q) ]]&amp;type=function&amp;fn-category=[[ encode-for-uri($cat) ]]">[[ $cat ]] <span class="facet-count">([[ $category-facets($cat) ]])</span></a>
                            [% endif %]
                        </li>
                        [% endfor %]
                    </ul>
                </div>
                [% endif %]

                [% if ($type-filter = 'function' or $type-filter = 'all') and map:size($prefix-facets) > 0 %]
                <div class="facet-group">
                    <h3 class="facet-heading">Module Namespace Prefix</h3>
                    <ul class="facet-list">
                        [% for $p in (for $k in map:keys($prefix-facets) order by $prefix-facets($k) descending return $k) %]
                        <li>
                            [% if $prefix-filter = $p %]
                            <span class="facet-link facet-active">[[ $p ]] <span class="facet-count">([[ $prefix-facets($p) ]])</span></span>
                            [% else %]
                            <a class="facet-link" href="[[ $app-base ]]/search?q=[[ encode-for-uri($q) ]]&amp;type=function&amp;prefix=[[ encode-for-uri($p) ]]">[[ $p ]] <span class="facet-count">([[ $prefix-facets($p) ]])</span></a>
                            [% endif %]
                        </li>
                        [% endfor %]
                    </ul>
                </div>
                [% endif %]

            </aside>

            <div class="search-results-main">
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
            </div>

        </div>
        [% endif %]
    </div>
</div>
