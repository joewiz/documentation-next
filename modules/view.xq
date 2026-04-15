xquery version "3.1";

(:~
 : Template view module.
 :
 : Two-pass rendering:
 :   Pass 1: Render the page-specific content template (article, function, etc.)
 :   Pass 2: Render page-content.tpl which extends the profile's base-page.html
 :
 : Uses the exist-site Jinks profile for shared nav, CSS, and base template.
 :)

import module namespace tmpl = "http://e-editiones.org/xquery/templates";
import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace dnav = "http://exist-db.org/apps/docs/nav"
    at "docs-nav.xqm";
import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "fundocs.xqm";
import module namespace docs = "http://exist-db.org/apps/docs/docs"
    at "docs.xqm";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html5";
declare option output:media-type "text/html";
declare option output:indent "no";

(:~
 : Load a resource as a string, whether stored as binary or XML.
 :)
declare function local:load-resource($path as xs:string) as xs:string? {
    if (util:binary-doc-available($path)) then
        util:binary-to-string(util:binary-doc($path))
    else if (doc-available($path)) then
        serialize(doc($path))
    else
        ()
};

(:~
 : Resolver for Jinks: handles both relative and absolute paths.
 : Profile files (base-page.html, nav.xqm) are in the deployed app.
 :)
declare function local:resolver($path as xs:string) as map(*)? {
    let $effectivePath :=
        if (starts-with($path, "/db/")) then $path
        else $config:app-root || "/" || $path
    let $content :=
        if (util:binary-doc-available($effectivePath)) then
            util:binary-to-string(util:binary-doc($effectivePath))
        else if (doc-available($effectivePath)) then
            serialize(doc($effectivePath))
        else ()
    return
        if ($content) then
            map { "path": $effectivePath, "content": $content }
        else ()
};

(:~
 : Build the shared rendering context.
 :)
declare function local:context($section as xs:string?, $route-context as map(*)) as map(*) {
    let $context-path := request:get-context-path() || "/apps/docs"
    let $raw-user := request:get-attribute("org.exist.login.user")
    let $user := if (exists($raw-user) and not($raw-user = ("guest", "nobody"))) then $raw-user else ()

    (: Tab CSS classes :)
    let $tabs := map:merge(
        for $tab in ("articles", "functions", "search", "admin")
        return map { $tab: if ($tab eq $section) then "active" else "" }
    )

    return map:merge((
        map {
            (: Profile context variables :)
            "context-path": $context-path,
            "styles": array {
                "resources/css/exist-site.css",
                "resources/css/docs.css"
            },
            "site": map {
                "name": "eXist-db",
                "logo": "resources/images/exist-logo.svg"
            },
            "nav": map {
                "items": array {
                    map { "abbrev": "dashboard", "title": "Dashboard" },
                    map { "abbrev": "docs", "title": "Documentation" },
                    map { "abbrev": "notebook", "title": "Notebook" },
                    map { "abbrev": "blog", "title": "Blog" }
                }
            },

            (: App-specific context :)
            "user": $user,
            "app-base": $context-path,
            "has-api": config:has-api(),
            "tabs": $tabs,
            "q": request:get-parameter("q", ""),
            "category": request:get-parameter("category", "all")
        },
        $route-context
    ))
};

(:~
 : Build route-specific context from request attributes.
 :)
declare function local:route-context() as map(*) {
    let $section := request:get-attribute("$section")
    let $prefix := request:get-attribute("$prefix")
    let $function-name := request:get-attribute("$function-name")
    let $slug := request:get-attribute("$slug")
    let $q := request:get-parameter("q", "")
    let $type := request:get-parameter("type", "all")
    let $category := request:get-parameter("category", "all")

    let $uri := request:get-parameter("uri", ())
    let $location := request:get-parameter("location", ())

    return

        (: === Articles === :)
        if ($section = "articles" and exists($slug) and $slug != "") then
            let $article := docs:load-article($slug)
            return
                if (exists($article)) then
                    map {
                        "page-title": $article?title,
                        "slug": $slug,
                        "article": $article,
                        "article-html": docs:render($article),
                        "toc": docs:toc($article),
                        "breadcrumb": dnav:breadcrumb("articles", $slug, ())
                    }
                else
                    map {
                        "page-title": "Article Not Found",
                        "breadcrumb": dnav:breadcrumb("articles", (), ())
                    }

        else if ($section = "articles") then
            map {
                "page-title": "Documentation",
                "article-categories": docs:list-by-category(),
                "breadcrumb": dnav:breadcrumb("articles", (), ())
            }

        (: === Functions === :)
        else if ($section = "functions" and exists($prefix) and exists($function-name)) then
            let $functions := fundocs:get-function($prefix, $function-name)
            return map {
                "page-title": $prefix || ":" || $function-name,
                "prefix": $prefix,
                "function-name": $function-name,
                "functions": array { $functions },
                "module": fundocs:get-module($prefix)[1],
                "breadcrumb": dnav:breadcrumb("functions", $prefix, $function-name)
            }

        else if ($section = "functions" and exists($prefix)) then
            let $modules := fundocs:get-module($prefix)
            return map {
                "page-title": $prefix || " module",
                "prefix": $prefix,
                "modules": array { $modules },
                "module": $modules[1],
                "breadcrumb": dnav:breadcrumb("functions", $prefix, ())
            }

        else if ($section = "functions" and exists($uri)) then
            let $module := fundocs:get-module-by-uri($uri, $location)
            return map {
                "page-title": ($module?prefix, "Module")[1],
                "prefix": $module?prefix,
                "module": $module,
                "modules": array { $module },
                "breadcrumb": dnav:breadcrumb("functions", $module?prefix, ())
            }

        else if ($section = "functions") then
            map {
                "page-title": "Function Reference",
                "categories": fundocs:list-modules($category),
                "breadcrumb": dnav:breadcrumb("functions", (), ())
            }

        (: === Search === :)
        else if ($section = "search") then
            let $fn-results := fundocs:search($q)
            let $article-results := docs:search($q)
            let $all-results := array {
                if ($type = "all" or $type = "function") then $fn-results?* else (),
                if ($type = "all" or $type = "article") then $article-results?* else ()
            }
            return map {
                "page-title":
                    if ($q != "") then "Search: " || $q
                    else "Search",
                "q": $q,
                "type-filter": $type,
                "search-results": $all-results,
                "function-count": array:size($fn-results),
                "article-count": array:size($article-results),
                "breadcrumb": dnav:breadcrumb("search", (), ())
            }

        (: === Admin === :)
        else if ($section = "admin") then
            map {
                "page-title": "Administration",
                "all-articles": docs:list-articles(),
                "breadcrumb": dnav:breadcrumb("admin", (), ())
            }

        (: === Default / 404 === :)
        else
            map {
                "page-title": "Documentation",
                "breadcrumb": dnav:breadcrumb("home", (), ())
            }
};

(: === Main entry point === :)

let $template-rel := request:get-attribute("template")
let $section := request:get-attribute("$section")
let $route-context := local:route-context()
let $ctx := local:context($section, $route-context)
let $jinksCfg := map {
    "resolver": local:resolver#1,
    "modules": map {
        "http://exist-db.org/site/nav": map {
            "prefix": "nav",
            "at": "/db/apps/exist-site-shell/modules/nav.xqm"
        },
        "http://exist-db.org/site/shell-config": map {
            "prefix": "site-config",
            "at": "/db/apps/exist-site-shell/modules/site-config.xqm"
        }
    }
}

(: Pass 1: render page-specific content template :)
let $content-tpl := local:load-resource($config:app-root || "/" || $template-rel)
let $tab-content :=
    if ($content-tpl) then
        tmpl:process($content-tpl, $ctx, $jinksCfg)
    else
        <div>Content template not found: { $template-rel }</div>

(: Pass 2: render page-content.tpl which extends profile's base-page.html :)
let $wrapper-tpl := local:load-resource($config:app-root || "/templates/page-content.tpl")
let $wrapper-ctx := map:merge(($ctx, map { "tab-content": $tab-content }))
return
    if ($wrapper-tpl) then
        tmpl:process($wrapper-tpl, $wrapper-ctx, $jinksCfg)
    else
        (: Minimal fallback if page-content.tpl is missing :)
        <html lang="en">
            <head>
                <meta charset="UTF-8"/>
                <title>{ $ctx?page-title } — Documentation</title>
            </head>
            <body>
                <main>{ $tab-content }</main>
            </body>
        </html>
