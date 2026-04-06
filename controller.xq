xquery version "3.1";

(:~
 : URL routing controller for the documentation app.
 :
 : Routes:
 :   /                              - landing (article index)
 :   /articles/                     - article index by category
 :   /articles/{slug}               - article detail
 :   /functions/                    - module browser
 :   /functions/view?uri=...        - module detail by URI (disambiguation)
 :   /functions/{prefix}/           - module detail by prefix
 :   /functions/{prefix}/{name}     - function detail
 :   /search?q=...&type=...         - search results
 :   /admin/                        - admin panel
 :   /api/xqdoc/regenerate          - POST: regenerate XQDoc data (setgid DBA)
 :   /api/articles/convert          - POST: convert DocBook → XDITA (setgid DBA)
 :   /api/articles/{slug}/xdita     - GET/PUT: load/save XDITA for editor
 :   /resources/*                   - static assets
 :)

declare namespace exist = "http://exist.sourceforge.net/NS/exist";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(: Helper: dispatch directly to view.xq which reads the template itself :)
declare function local:view(
    $template as xs:string,
    $attributes as element(exist:set-attribute)*
) {
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/view.xq">
            <set-attribute name="template" value="templates/{$template}"/>
            { $attributes }
        </forward>
    </dispatch>
};

(: Normalize path: strip trailing slash for matching :)
let $path := replace($exist:path, "/$", "")

return

(: Landing page — article index :)
if ($path = "" or $path = "/") then
    local:view("article-index.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="articles"/>
    ))

(: Article index :)
else if ($path = "/articles") then
    local:view("article-index.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="articles"/>
    ))

(: Article assets — images, listings, etc.
 : Maps /articles/{slug}/assets/foo.png → data/articles/{slug}/assets/foo.png
 : Must come BEFORE article detail route since both match /articles/* :)
else if (starts-with($path, "/articles/") and
         matches($exist:path, "\.(png|jpg|jpeg|gif|svg|txt|xml|xq|xql|xqm|css|js)$")) then
    let $rel := substring-after($exist:path, "/articles/")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/data/articles/{$rel}">
                <cache-control cache="yes"/>
            </forward>
        </dispatch>

(: Article detail: /articles/{slug}/
 : Redirect /articles/{slug} → /articles/{slug}/ so relative asset paths resolve correctly :)
else if (starts-with($exist:path, "/articles/") and
         not(contains(substring-after($exist:path, "/articles/"), "/")) and
         not(ends-with($exist:path, "/"))) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>

else if (starts-with($path, "/articles/")) then
    let $slug := replace(substring-after($path, "/articles/"), "/.*$", "")
    return
        local:view("article.tpl", (
            <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                name="$section" value="articles"/>,
            <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                name="$slug" value="{$slug}"/>
        ))

(: Redirect /data/articles/{slug}/{slug}.xml → /articles/{slug}
 : This handles URLs from sitewide search which derive paths from the database :)
else if (starts-with($exist:path, "/data/articles/") and
         matches($exist:path, "\.xml$")) then
    let $slug := replace($exist:path, "^/data/articles/([^/]+)/.*$", "$1")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="{request:get-context-path()}{$exist:prefix}{$exist:controller}/articles/{$slug}"/>
        </dispatch>

(: Article data assets — images, listings, etc. :)
else if (starts-with($exist:path, "/data/articles/") and
         matches($exist:path, "\.(png|jpg|jpeg|gif|svg|txt)$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}{$exist:path}">
            <cache-control cache="yes"/>
        </forward>
    </dispatch>

(: Redirect /data/functions/*.xml → /functions/{prefix}/
 : Looks up the module prefix from the XQDoc document :)
else if (starts-with($exist:path, "/data/functions/") and
         matches($exist:path, "\.xml$")) then
    let $doc-path := $exist:controller || $exist:path
    let $prefix :=
        try { doc($doc-path)//*:name[parent::*:module]/string() }
        catch * { () }
    return
        if ($prefix and $prefix != "") then
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <redirect url="{request:get-context-path()}{$exist:prefix}{$exist:controller}/functions/{$prefix}/"/>
            </dispatch>
        else
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <redirect url="{request:get-context-path()}{$exist:prefix}{$exist:controller}/functions/"/>
            </dispatch>

(: Static resources :)
else if (starts-with($exist:path, "/resources/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}{$exist:path}">
            <cache-control cache="yes"/>
        </forward>
    </dispatch>

(: Search :)
else if ($path = "/search") then
    local:view("search-results.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="search"/>
    ))

(: Admin :)
else if ($path = "/admin") then
    local:view("admin.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="admin"/>
    ))

(: API: regenerate XQDoc data (POST only, runs setgid DBA) :)
else if ($path = "/api/xqdoc/regenerate" and request:get-method() = "POST") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/regenerate.xq"/>
    </dispatch>

(: API: convert DocBook articles to XDITA (POST only, runs setgid DBA) :)
else if ($path = "/api/articles/convert" and request:get-method() = "POST") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/convert-api.xq"/>
    </dispatch>

(: API: load/save XDITA article content for editor :)
else if (matches($path, "^/api/articles/[^/]+/xdita$")) then
    let $slug := replace($path, "^/api/articles/([^/]+)/xdita$", "$1")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/editor-api.xq">
                <set-attribute name="$slug" value="{ $slug }"/>
            </forward>
        </dispatch>

(: Functions: module browser :)
else if ($path = "/functions") then
    local:view("module-list.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="functions"/>
    ))

(: Functions: URI-based disambiguation :)
else if ($path = "/functions/view") then
    local:view("module-detail.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="functions"/>
    ))

(: Functions: module or function detail by path segments :)
else if (starts-with($path, "/functions/")) then
    let $rest := substring-after($path, "/functions/")
    let $parts := tokenize($rest, "/")
    let $prefix := $parts[1]
    let $func-name := $parts[2]
    return
        if (exists($func-name) and $func-name != "") then
            (: Function detail: /functions/{prefix}/{name} :)
            local:view("function-detail.tpl", (
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$section" value="functions"/>,
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$prefix" value="{$prefix}"/>,
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$function-name" value="{$func-name}"/>
            ))
        else
            (: Module detail: /functions/{prefix}/ :)
            local:view("module-detail.tpl", (
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$section" value="functions"/>,
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$prefix" value="{$prefix}"/>
            ))

(: 404 :)
else
    local:view("error-404.tpl", (
        <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
            name="$section" value="404"/>
    ))
