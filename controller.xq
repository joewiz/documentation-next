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
 :   /login                         - GET: login form; POST: authenticate
 :   /logout                        - clear session and redirect home
 :   /admin/                        - admin panel
 :   /api/xqdoc/regenerate          - POST: regenerate XQDoc data (setgid DBA)
 :   /api/articles/convert          - POST: convert DocBook → XDITA (setgid DBA)
 :   /api/articles/{slug}/xdita     - GET/PUT: load/save XDITA for editor
 :   /resources/*                   - static assets
 :)

import module namespace login="http://exist-db.org/xquery/login"
    at "resource:org/exist/xquery/modules/persistentlogin/login.xql";

declare namespace exist = "http://exist.sourceforge.net/NS/exist";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

declare variable $local:login-domain := "org.exist.login";

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

(: Process persistent login on every request :)
let $login := login:set-user($local:login-domain, xs:dayTimeDuration("P7D"), false())
let $user := request:get-attribute($local:login-domain || ".user")
let $method := lower-case(request:get-method())

(: Normalize path: strip trailing slash for matching :)
let $path := replace($exist:path, "/$", "")

return

(: --- Login (GET) --- :)
if ($exist:resource eq "login" and $method eq "get") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/login.html"/>
    </dispatch>

(: --- Login (POST) --- :)
else if ($exist:resource eq "login" and $method eq "post") then
    let $base := request:get-context-path() || "/apps/docs"
    return
        if ($user and not($user = ("guest", "nobody"))) then
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <redirect url="{request:get-parameter('redirect', $base || '/admin')}"/>
            </dispatch>
        else
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <redirect url="{$base}/login?error=1"/>
            </dispatch>

(: --- Logout --- :)
else if ($exist:resource eq "logout") then (
    response:set-cookie($local:login-domain, "deleted", xs:dayTimeDuration("-P1D"), false(), (),
        request:get-context-path()),
    session:invalidate(),
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-context-path()}/apps/docs/"/>
    </dispatch>
)

(: Landing page — article index :)
else if ($path = "" or $path = "/") then
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

else if (starts-with($path, "/articles/")) then
    let $slug := replace(substring-after($path, "/articles/"), "/.*$", "")
    return
        local:view("article.tpl", (
            <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                name="$section" value="articles"/>,
            <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                name="$slug" value="{$slug}"/>
        ))

(: Article data assets — images, listings, etc. :)
else if (starts-with($exist:path, "/data/articles/") and
         matches($exist:path, "\.(png|jpg|jpeg|gif|svg|txt)$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}{$exist:path}">
            <cache-control cache="yes"/>
        </forward>
    </dispatch>

(: Redirect /data/articles/{slug}/... → /articles/{slug}
 : Handles URLs derived from database paths by sitewide search (with or without .xml extension) :)
else if (starts-with($exist:path, "/data/articles/") and
         contains(substring-after($exist:path, "/data/articles/"), "/")) then
    let $slug := replace($exist:path, "^/data/articles/([^/]+)/.*$", "$1")
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="{request:get-context-path()}{$exist:prefix}{$exist:controller}/articles/{$slug}"/>
        </dispatch>

(: Redirect /data/functions/*.xml or extensionless → /functions/{prefix}/
 : Handles URLs derived from database paths by sitewide search :)
else if (starts-with($exist:path, "/data/functions/") and
         (matches($exist:path, "\.xml$") or not(contains(substring-after($exist:path, "/data/functions/"), ".")))) then
    let $filename := substring-after($exist:path, "/data/functions/")
    let $filename-xml := if (matches($filename, "\.xml$")) then $filename else $filename || ".xml"
    let $db-path := "/db/apps/docs/data/functions/" || $filename-xml
    let $prefix :=
        try { doc($db-path)//*:name[parent::*:module]/string() }
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
    let $arity := $parts[3]
    return
        if (exists($func-name) and $func-name != "") then
            (: Function detail: /functions/{prefix}/{name}[/{arity}] :)
            local:view("function-detail.tpl", (
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$section" value="functions"/>,
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$prefix" value="{$prefix}"/>,
                <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                    name="$function-name" value="{$func-name}"/>,
                if (exists($arity) and $arity != "") then
                    <set-attribute xmlns="http://exist.sourceforge.net/NS/exist"
                        name="$arity" value="{$arity}"/>
                else ()
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
