xquery version "3.1";

(:~
 : App navigation module.
 :
 : Provides breadcrumb data for templates. The top-level nav bar is
 : handled by the exist-site Jinks profile (modules/nav.xqm from profile).
 :)
module namespace nav = "http://exist-db.org/apps/docs/nav";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

(:~
 : Build breadcrumb trail.
 :
 : @param $section current section
 : @param $detail optional detail identifier (prefix for functions, slug for articles)
 : @param $sub optional sub-detail (function name)
 : @return array of breadcrumb maps with title and url
 :)
declare function nav:breadcrumb(
    $section as xs:string,
    $detail as xs:string?,
    $sub as xs:string?
) as array(*) {
    array {
        map { "title": "Documentation", "url": $config:app-base || "/" },

        if ($section = "articles") then (
            map {
                "title": "Articles",
                "url": $config:app-base || "/articles/"
            },
            if ($detail) then
                let $title := nav:article-title($detail)
                return map {
                    "title": ($title, $detail)[1],
                    "url": ()
                }
            else ()
        )
        else if ($section = "functions") then (
            map {
                "title": "Functions",
                "url": $config:app-base || "/functions/"
            },
            if ($detail) then
                map {
                    "title": $detail,
                    "url": $config:app-base || "/functions/" || $detail || "/"
                }
            else (),
            if ($sub) then
                map {
                    "title": $sub,
                    "url": ()
                }
            else ()
        )
        else if ($section = "search") then
            map { "title": "Search", "url": () }
        else if ($section = "admin") then
            map { "title": "Admin", "url": () }
        else ()
    }
};

(:~
 : Look up an article title by slug for breadcrumbs.
 :)
declare %private function nav:article-title($slug as xs:string) as xs:string? {
    let $col := $config:data-root || "/articles/" || $slug
    return
        if (xmldb:collection-available($col)) then
            collection($col)/topic/title/string()
        else
            ()
};
