xquery version "3.1";

(:~
 : Site-wide search configuration for the docs app.
 :
 : Implements the site-search convention: the site-shell dynamically loads
 : this module from each registered app and calls site-search:hits() to
 : collect full-text search results with site-* Lucene fields attached.
 :
 : Query preprocessing
 : -------------------
 : XQuery function names use prefix:local-name syntax.  Lucene's query parser
 : treats the colon as a field separator, so "file:sync" is parsed as field
 : "file", term "sync" — which fails.  We handle this with two strategies:
 :
 :   1. For SimpleAnalyzer-indexed elements (xqdoc:xqdoc, xqdoc:function):
 :      convert "file:sync" to the phrase query "file sync".  SimpleAnalyzer
 :      splits on colons, so the adjacent tokens match.
 :
 :   2. For KeywordAnalyzer-indexed elements (xqdoc:name):
 :      escape the colon as "file\:sync" so the query parser treats it as a
 :      literal colon.  KeywordAnalyzer stores "file:sync" as one token, so
 :      the escaped query matches exactly.
 :)
module namespace site-search = "http://exist-db.org/site/search-config";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

declare namespace xqdoc = "http://www.xqdoc.org/1.0";

(:~
 : Return elements matching a sitewide full-text query.
 :
 : Every returned element MUST have site-content, site-title, site-url,
 : site-app, and site-section Lucene fields indexed on it so that the
 : site-shell can call ft:field(), ft:facets(), and ft:score().
 :
 : @param $q    the search query string
 : @param $opts ft:query options (typically map { "fields": "site-content" })
 : @return matching elements with Lucene context intact
 :)
declare function site-search:hits(
    $q as xs:string,
    $opts as map(*)
) as element()* {
    let $fn-root := $config:functions-data
    let $articles-root := $config:data-root || "/articles"

    (: Preprocess queries containing prefix:name patterns :)
    let $has-colon := matches($q, '\w+:\w+')
    (: SimpleAnalyzer splits on colons → use phrase query for adjacency :)
    let $simple-q := if ($has-colon) then replace($q, '(\w+):(\w+)', '"$1 $2"') else $q
    (: KeywordAnalyzer keeps the colon → escape it as a literal :)
    let $kw-q := if ($has-colon) then replace($q, '(\w+):(\w+)', '$1\\:$2') else $q

    return (
        (: Module-level hits (SimpleAnalyzer) :)
        collection($fn-root)/xqdoc:xqdoc[ft:query(., $simple-q, $opts)],
        (: Function-level hits (SimpleAnalyzer) :)
        collection($fn-root)//xqdoc:function[ft:query(., $simple-q, $opts)],
        (: Function name exact match (KeywordAnalyzer on xqdoc:name) :)
        collection($fn-root)//xqdoc:function/xqdoc:name[ft:query(., $kw-q, $opts)],
        (: Article hits :)
        collection($articles-root)//topic[ft:query(., $simple-q, $opts)]
    )
};
