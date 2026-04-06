# Site-Shell Search: `site-*` Field Convention

## Overview

Apps contribute to sitewide search by defining Lucene index fields with the `site-` prefix. The site-shell's search module queries these fields to produce unified search results across all installed apps.

## Field Definitions

| Field | Purpose | Example |
|-------|---------|---------|
| `site-content` | Searchable text (queried by `ft:query`) | Article body, function names + descriptions |
| `site-title` | Display title for the search result | "Containerization via Docker", "http://www.w3.org/2005/xpath-functions" |
| `site-app` | App identifier (for filtering/display) | "docs", "blog", "notebook" |
| `site-section` | Section within the app | "articles", "functions" |
| `site-url` | **NEW** — Clean URL path relative to the app root | "articles/docker", "functions/fn/" |

## How `site-url` Works

Apps store the clean URL path in the indexed document. For documents where the database path doesn't match the user-facing URL, `site-url` provides the correct link target.

**Articles** (DocBook) — URL injected as a processing instruction during post-install:
```xml
<article xmlns="http://docbook.org/ns/docbook" version="5.0">
    <?site-url articles/docker?>
    <info><title>Containerization via Docker</title>...</info>
    ...
</article>
```

Index config:
```xml
<text qname="db:article">
    <field name="site-url" expression="processing-instruction('site-url')"/>
</text>
```

**Function modules** (XQDoc) — URL stored as an element during generation:
```xml
<xqdoc:xqdoc>
    <xqdoc:control>
        <xqdoc:date>...</xqdoc:date>
        <xqdoc:location>...</xqdoc:location>
        <xqdoc:site-url>functions/fn/</xqdoc:site-url>
    </xqdoc:control>
    ...
</xqdoc:xqdoc>
```

Index config:
```xml
<text qname="xqdoc:xqdoc">
    <field name="site-url" expression="xqdoc:control/xqdoc:site-url"/>
</text>
```

## Changes Needed in `exist-site-shell`

### `modules/search.xqm` — Update `search:derive-url()`

Replace the current path-based URL derivation with a field-first approach:

```xquery
declare %private function search:derive-url($hit as node()) as xs:string {
    let $field-url := ft:field($hit, "site-url", "xs:string")
    let $field-app := ft:field($hit, "site-app", "xs:string")
    return
        if ($field-url != "") then
            (: App provided a clean URL — resolve relative to the app's base path :)
            let $app-base := request:get-context-path() || "/apps/" || $field-app
            return
                $app-base || "/" || $field-url
        else
            (: Fallback: derive URL from database path :)
            let $doc-uri := document-uri(root($hit))
            let $rel-path := substring-after($doc-uri, "/db/apps/")
            return
                if ($rel-path) then
                    request:get-context-path() || "/apps/" || $rel-path
                else
                    "#"
};
```

### `templates/search-results.tpl` (or equivalent) — Update result links

The `$result?url` value will now be a clean URL like `/exist/apps/docs/articles/docker` instead of `/exist/apps/docs/data/articles/docker/docker.xml`.

### `templates/search-results.tpl` — Optionally display section

The `site-section` field enables grouping or badge display:

```html
[% if $result?section != '' %]
<span class="search-section">[[ $result?section ]]</span>
[% endif %]
```

## Migration Path

1. Update `search:derive-url()` in site-shell to check `site-url` first (backward-compatible — falls back to path derivation)
2. Apps that define `site-url` get clean URLs in search results immediately
3. Apps without `site-url` continue to work with path-derived URLs
4. Over time, all stock apps adopt the `site-*` field convention

## Currently Implementing `site-*` Fields

| App | `site-content` | `site-title` | `site-app` | `site-section` | `site-url` |
|-----|:-:|:-:|:-:|:-:|:-:|
| **docs** (documentation-next) | ✓ | ✓ | ✓ | ✓ | ✓ |
| notebook | (uses `body`) | (uses `title`) | — | — | — |
| blog | — | — | — | — | — |
| fundocs (legacy) | — | — | — | — | — |
