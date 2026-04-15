<div class="docs-layout docs-article-layout">
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

        [% if exists($user) %]
        <div class="article-actions">
            <a href="[[ $app-base ]]/admin?edit=[[ $slug ]]" class="btn btn-secondary btn-sm">Edit Article</a>
        </div>
        [% endif %]

        <article class="xdita-article">
            [[ $article-html ]]
        </article>

        [% if $article?date != '' %]
        <footer class="article-footer">
            <p class="article-updated">Last updated: [[ $article?date ]]</p>
        </footer>
        [% endif %]
    </div>

    <aside class="docs-sidebar">
        <nav class="toc" aria-label="Table of contents">
            <h3>Contents</h3>
            <ul>
                [% for $entry in $toc?* %]
                <li>
                    <a href="#[[ $entry?id ]]">[[ $entry?title ]]</a>
                    [% if array:size($entry?children) > 0 %]
                    <ul>
                        [% for $child in $entry?children?* %]
                        <li><a href="#[[ $child?id ]]">[[ $child?title ]]</a></li>
                        [% endfor %]
                    </ul>
                    [% endif %]
                </li>
                [% endfor %]
            </ul>
        </nav>
    </aside>
</div>
