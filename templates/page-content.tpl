---json
{
    "templating": {
        "extends": "templates/base-page.html"
    }
}
---
[% template title %][[ $page-title ]] -- Documentation[% endtemplate %]

[% template head %]
[% if exists($slug) %]
<base href="[[ $context-path ]]/articles/[[ $slug ]]/"/>
[% endif %]
<link rel="icon" href="[[ $context-path ]]/resources/favicon.ico"/>
<link rel="stylesheet" href="[[ $context-path ]]/resources/odd/xdita.css"/>
[% if $tabs?admin = "active" %]
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
<link rel="stylesheet" href="[[ $context-path ]]/resources/vendor/jinntap/jinn-tap.css"/>
<link rel="stylesheet" href="[[ $context-path ]]/resources/vendor/jinntap/editor-styles.css"/>
<link rel="stylesheet" href="[[ $context-path ]]/resources/css/editor-xdita.css"/>
[% endif %]
[% endtemplate %]

[% template content %]
<nav class="app-tabs" aria-label="Documentation navigation">
    <ul>
        <li><a href="[[ $context-path ]]/articles" class="[[ $tabs?articles ]]">Articles</a></li>
        <li><a href="[[ $context-path ]]/functions" class="[[ $tabs?functions ]]">Functions</a></li>
        <li><a href="[[ $context-path ]]/search" class="[[ $tabs?search ]]">Search</a></li>
        <li><a href="[[ $context-path ]]/admin" class="[[ $tabs?admin ]]">Admin</a></li>
    </ul>
</nav>
<div class="docs-app">
    <section class="docs-content">
        [[ $tab-content ]]
    </section>
</div>
<script src="[[ $context-path ]]/resources/js/highlight-bundle.js"></script>
<script src="[[ $context-path ]]/resources/js/docs.js"></script>
[% if $has-api %]
<script type="module" src="[[ $context-path ]]/resources/vendor/jinn-codemirror/jinn-codemirror-bundle.js"></script>
<script src="[[ $context-path ]]/resources/js/tryit.js"></script>
[% endif %]
[% if $tabs?admin = "active" %]
<script type="module" src="[[ $context-path ]]/resources/vendor/jinntap/jinn-tap.es.js"></script>
[% endif %]
[% endtemplate %]
