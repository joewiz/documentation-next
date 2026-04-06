xquery version "3.1";

(:~
 : XDITA article module.
 :
 : Handles loading, rendering (via compiled XDITA ODD), and table of contents
 : generation for Lightweight DITA (XDITA) topic documents.
 :
 : XDITA elements use no namespace (bare elements in default namespace).
 :)
module namespace xdita = "http://exist-db.org/apps/docs/xdita";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace pm-config = "http://www.tei-c.org/tei-simple/pm-config"
    at "pm-config.xql";

(: ========================= :)
(:  Article Loading          :)
(: ========================= :)

(:~
 : Load an XDITA topic article by slug.
 :
 : Looks for a <topic> root element (no namespace) in the article collection.
 :
 : @param $slug the article slug (directory name)
 : @return map with topic XML, metadata, and slug — or empty if not found
 :)
declare function xdita:load-article($slug as xs:string) as map(*)? {
    let $articles-root := $config:data-root || "/articles"
    let $collection := $articles-root || "/" || $slug
    return
        if (xmldb:collection-available($collection)) then
            (: XDITA topics have no namespace — match bare <topic> :)
            let $topic := collection($collection)/topic
            return
                if (exists($topic)) then
                    map {
                        "slug": $slug,
                        "doc": $topic,
                        "format": "xdita",
                        "title": $topic/title/string(),
                        "date": $topic/prolog/data[@name = "date"]/@value/string(),
                        "keywords": array {
                            $topic/prolog/data[@name = "keyword"]/@value/string()
                        }
                    }
                else ()
        else ()
};

(: ========================= :)
(:  Rendering via ODD        :)
(: ========================= :)

(:~
 : Render an XDITA topic to HTML using the compiled ODD transform.
 :
 : @param $topic the XDITA topic element
 : @return HTML fragment
 :)
declare function xdita:render($topic as element(topic)) as node()* {
    $pm-config:xdita-web-transform(map {
        "root": $topic,
        "webcomponents": 7
    }, $topic)
};

(: ========================= :)
(:  Table of Contents        :)
(: ========================= :)

(:~
 : Generate a table of contents from the XDITA section structure.
 :
 : XDITA sections are flat (no sect1/sect2 distinction), but can be
 : nested. We produce a two-level TOC from the section hierarchy.
 :
 : @param $topic the XDITA topic element
 : @return array of TOC entry maps with title, id, and children
 :)
declare function xdita:toc($topic as element(topic)) as array(*) {
    array {
        for $section in $topic/body/section
        let $id := ($section/@id/string(), generate-id($section))[1]
        return map {
            "title": $section/title/string(),
            "id": $id,
            "children": array {
                for $subsection in $section/section
                let $sub-id := ($subsection/@id/string(), generate-id($subsection))[1]
                return map {
                    "title": $subsection/title/string(),
                    "id": $sub-id
                }
            }
        }
    }
};

(: ========================= :)
(:  Search                   :)
(: ========================= :)

(:~
 : Search XDITA articles using Lucene full-text.
 :
 : @param $q the search query
 : @return array of result maps
 :)
declare function xdita:search($q as xs:string) as array(*) {
    if ($q = "") then
        array {}
    else
        let $articles-root := $config:data-root || "/articles"
        let $hits := collection($articles-root)//topic
            [ft:query(., $q, map { "fields": "site-content" })]
        return array {
            for $hit in $hits
            let $doc-uri := document-uri(root($hit))
            let $slug := xdita:uri-to-slug($doc-uri)
            let $title := $hit/title/string()
            order by ft:score($hit) descending
            return map {
                "slug": $slug,
                "title": $title,
                "description": substring(
                    string-join($hit/body/section[1]/p[1]//text(), " "), 1, 200
                ),
                "score": ft:score($hit),
                "type": "article"
            }
        }
};

(: ========================= :)
(:  Helpers                  :)
(: ========================= :)

(:~
 : Extract article slug from a database URI.
 :)
declare %private function xdita:uri-to-slug($uri as xs:string) as xs:string {
    let $parts := tokenize(replace($uri, "^.*/articles/", ""), "/")
    return $parts[1]
};
