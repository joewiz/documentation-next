xquery version "3.1";

(:~
 : Article documentation module.
 :
 : Handles XDITA article loading, rendering, table of contents generation,
 : and article listing.
 :)
module namespace docs = "http://exist-db.org/apps/docs/docs";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace xdita = "http://exist-db.org/apps/docs/xdita"
    at "xdita.xqm";

(: ========================= :)
(:  Article Discovery        :)
(: ========================= :)

(:~
 : List all available articles with metadata.
 :
 : @return array of article maps with slug, title, date, keywords, description, format
 :)
declare function docs:list-articles() as array(*) {
    let $articles-root := $config:data-root || "/articles"
    return array {
        for $topic in collection($articles-root)/topic
        let $doc-uri := document-uri(root($topic))
        (: Skip plain .xml when a .xdita.xml (edited version) exists for the same article :)
        where not(
            ends-with($doc-uri, ".xml")
            and not(ends-with($doc-uri, ".xdita.xml"))
            and doc-available(replace($doc-uri, "\.xml$", ".xdita.xml"))
        )
        let $slug := docs:uri-to-slug($doc-uri)
        order by ($topic/title/string(), $slug)[1]
        return map {
            "slug": $slug,
            "title": $topic/title/string(),
            "date": $topic/prolog/data[@name = "date"]/@value/string(),
            "keywords": array {
                $topic/prolog/data[@name = "keyword"]/@value/string()
            },
            "description": substring(
                string-join($topic/body/section[1]/p[1]//text(), " "), 1, 200
            ),
            "format": "xdita"
        }
    }
};

(:~
 : List articles grouped by keyword/category.
 :
 : @return array of category maps with title and articles array
 :)
declare function docs:list-by-category() as array(*) {
    let $all := docs:list-articles()
    let $categories := map {
        "getting-started": "Getting Started",
        "application-development": "Application Development",
        "operations": "Administration &amp; Operations",
        "java-development": "Java Development",
        "indexes": "Indexing",
        "security": "Security"
    }
    let $category-order := (
        "getting-started", "application-development", "operations",
        "java-development", "indexes", "security"
    )
    return array {
        for $cat in $category-order
        let $articles :=
            for $a in $all?*
            where $cat = $a?keywords?*
            return $a
        where exists($articles)
        return map {
            "id": $cat,
            "title": $categories($cat),
            "articles": array { $articles }
        },
        (: Uncategorized articles :)
        let $categorized-slugs :=
            for $cat in $category-order
            for $a in $all?*
            where $cat = $a?keywords?*
            return $a?slug
        let $uncategorized :=
            for $a in $all?*
            where not($a?slug = $categorized-slugs)
            return $a
        return
            if (exists($uncategorized)) then
                map {
                    "id": "other",
                    "title": "Other Topics",
                    "articles": array { $uncategorized }
                }
            else ()
    }
};

(: ========================= :)
(:  Article Loading          :)
(: ========================= :)

(:~
 : Load an article by slug.
 :
 : @param $slug the article slug (e.g., "basic-installation")
 : @return map with article XML, metadata, slug, and format
 :)
declare function docs:load-article($slug as xs:string) as map(*)? {
    xdita:load-article($slug)
};

(: ========================= :)
(:  Rendering                :)
(: ========================= :)

(:~
 : Render an article to HTML.
 :
 : @param $article map from docs:load-article()
 : @return HTML fragment
 :)
declare function docs:render($article as map(*)) as node()* {
    xdita:render($article?doc)
};

(: ========================= :)
(:  Table of Contents        :)
(: ========================= :)

(:~
 : Generate a table of contents.
 :
 : @param $article map from docs:load-article()
 : @return array of TOC entry maps with title, id, and children
 :)
declare function docs:toc($article as map(*)) as array(*) {
    xdita:toc($article?doc)
};

(: ========================= :)
(:  Search                   :)
(: ========================= :)

(:~
 : Search articles using Lucene full-text.
 :
 : @param $q the search query
 : @return array of result maps
 :)
declare function docs:search($q as xs:string) as array(*) {
    xdita:search($q)
};

(: ========================= :)
(:  Helpers                  :)
(: ========================= :)

(:~
 : Extract article slug from a database URI.
 : e.g., /db/apps/docs/data/articles/docker/docker.xml → "docker"
 :)
declare %private function docs:uri-to-slug($uri as xs:string) as xs:string {
    let $parts := tokenize(replace($uri, "^.*/articles/", ""), "/")
    return $parts[1]
};
