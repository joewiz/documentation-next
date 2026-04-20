xquery version "3.1";

(:~
 : Extension module for documentation-specific ODD processing behaviours.
 :
 : Called by the compiled XDITA ODD transform when it encounters elements
 : with custom outputclass attributes (e.g., indexontitle, indexonkeyword).
 :)
module namespace ext = "http://exist-db.org/apps/docs/ext";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

(:~
 : Generate an alphabetical index of all articles by title.
 : Triggered by <p outputclass="indexontitle"/> in the documentation overview.
 :)
declare function ext:indexontitle($config as map(*), $node as element(), $class as xs:string+, $content) {
    let $articles := collection($config:data-root || "/articles")//topic
    return
        <dl class="article-index">{
            for $topic in $articles
            let $title := $topic/title/string()
            let $slug := replace(base-uri($topic), "^.*/([^/]+)/[^/]+$", "$1")
            where $slug != "documentation" and $slug != "xdita-test"
            order by lower-case($title)
            return (
                <dt><a href="articles/{$slug}">{$title}</a></dt>,
                <dd>{
                    let $desc := $topic/body/shortdesc/string()
                    return if ($desc) then $desc
                    else substring(string-join($topic/body//p[1]//text(), " "), 1, 150) || "..."
                }</dd>
            )
        }</dl>
};

(:~
 : Generate an index of articles grouped by subject keyword.
 : Triggered by <p outputclass="indexonkeyword"/> in the documentation overview.
 :)
declare function ext:indexonkeyword($config as map(*), $node as element(), $class as xs:string+, $content) {
    let $articles := collection($config:data-root || "/articles")//topic
    let $all-keywords :=
        distinct-values(
            for $topic in $articles
            return $topic/prolog/data[@name="keyword"]/@value/string()
        )
    return
        <div class="subject-index">{
            for $keyword in $all-keywords
            order by $keyword
            return
                <section class="subject-group">
                    <h3>{replace($keyword, "-", " ") => upper-case() => replace("^(.)", "$1")}</h3>
                    <ul>{
                        for $topic in $articles[prolog/data[@name="keyword"][@value=$keyword]]
                        let $title := $topic/title/string()
                        let $slug := replace(base-uri($topic), "^.*/([^/]+)/[^/]+$", "$1")
                        where $slug != "documentation"
                        order by lower-case($title)
                        return
                            <li><a href="articles/{$slug}">{$title}</a></li>
                    }</ul>
                </section>
        }</div>
};
