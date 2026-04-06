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

        <h1>Documentation</h1>
        <p class="lead">Guides, tutorials, and reference material for eXist-db.</p>

        [% for $cat in $article-categories?* %]
        <section class="article-category" id="category-[[ $cat?id ]]">
            <h2>[[ $cat?title ]]</h2>
            <ul class="article-list">
                [% for $a in $cat?articles?* %]
                <li class="article-item">
                    <a href="[[ $app-base ]]/articles/[[ $a?slug ]]">[[ $a?title ]]</a>
                    [% if $a?description != '' %]
                    <p class="article-description">[[ $a?description ]]</p>
                    [% endif %]
                </li>
                [% endfor %]
            </ul>
        </section>
        [% endfor %]
    </div>
</div>
