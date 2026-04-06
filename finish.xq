xquery version "3.1";

(:~
 : Post-install script.
 :
 : 1. Creates data collections and installs index configurations
 : 2. Compiles xdita.odd into XQuery transform modules (via tei-publisher-lib)
 : 3. Sets setgid on API scripts
 : 4. Injects site-url PIs into XDITA articles for sitewide search
 : 5. Generates XQDoc data for function reference
 : 6. Reindexes both articles and functions
 :)

import module namespace pmu = "http://www.tei-c.org/tei-simple/xquery/util";
import module namespace odd = "http://www.tei-c.org/tei-simple/odd2odd";
import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "modules/fundocs.xqm";

(: External variables set by the package manager :)
declare variable $home external;
declare variable $dir external;
declare variable $target external;

(: --- Step 1: Create data and transform collections --- :)
let $_ := (
    if (not(xmldb:collection-available($target || "/data"))) then
        xmldb:create-collection($target, "data")
    else (),
    if (not(xmldb:collection-available($target || "/data/functions"))) then
        xmldb:create-collection($target || "/data", "functions")
    else (),
    if (not(xmldb:collection-available($target || "/data/articles"))) then
        xmldb:create-collection($target || "/data", "articles")
    else (),
    if (not(xmldb:collection-available($target || "/transform"))) then
        xmldb:create-collection($target, "transform")
    else ()
)

(: --- Step 1b: Install index configurations from deployed app --- :)
let $sys-config := "/db/system/config" || $target
let $_ := (
    let $functions-xconf := doc($target || "/collection.xconf")
    return
        if (exists($functions-xconf)) then
            xmldb:store($sys-config || "/data/functions", "collection.xconf", $functions-xconf)
        else
            util:log("WARN", "collection.xconf not found"),
    let $articles-xconf := doc($target || "/articles-collection.xconf")
    return
        if (exists($articles-xconf)) then
            xmldb:store($sys-config || "/data/articles", "collection.xconf", $articles-xconf)
        else
            util:log("WARN", "articles-collection.xconf not found")
)

(: --- Step 2: Compile XDITA ODD into transform modules --- :)
let $odd-root := $target || "/resources/odd"
let $transform-root := $target || "/transform"
let $odd-config := doc($odd-root || "/configuration.xml")/*
let $_ :=
    try {
        let $compiled := odd:get-compiled($odd-root, "xdita.odd")
        return
            pmu:process-odd(
                $compiled,
                $transform-root,
                "web",
                "transform",
                $odd-config,
                true()
            )
    } catch * {
        util:log("WARN", (
            "documentation-next: XDITA ODD compilation note (",
            $err:code, "): ", $err:description
        ))
    }

(: --- Step 3: Set setgid on API scripts --- :)
let $_ :=
    for $script in ("regenerate.xq", "convert-api.xq", "editor-api.xq")
    let $path := xs:anyURI($target || "/modules/" || $script)
    return
        if (util:binary-doc-available($path) or doc-available($path)) then (
            sm:chown($path, "admin"),
            sm:chgrp($path, "dba"),
            sm:chmod($path, "rwxr-sr-x")
        ) else
            util:log("WARN", $script || " not found — skipping setgid setup")

(: --- Step 4: Inject site-url into XDITA articles for sitewide search --- :)
let $articles-root := $target || "/data/articles"
let $_ :=
    for $topic in collection($articles-root)/topic
    let $doc-uri := document-uri(root($topic))
    let $slug := replace($doc-uri, "^.*/articles/([^/]+)/.*$", "$1")
    let $site-url := "articles/" || $slug
    return (
        for $pi in $topic/processing-instruction('site-url')
        return update delete $pi,
        update insert processing-instruction site-url { $site-url }
            into $topic
    )

(: --- Step 5: Generate XQDoc for function reference --- :)
let $summary := fundocs:generate-all()

(: --- Step 6: Reindex both data collections --- :)
let $_ := xmldb:reindex($target || "/data/functions")
let $_ := xmldb:reindex($target || "/data/articles")

(: --- Step 7: Run Jinks generator to copy profile files --- :)
let $jinks-config := map {
    "label": "eXist-db Documentation",
    "id": "http://exist-db.org/apps/docs",
    "description": "Documentation and function reference for eXist-db",
    "extends": array { "exist-site" },
    "pkg": map {
        "abbrev": "docs",
        "version": "0.1.0"
    },
    "nav": map {
        "items": array {
            map { "abbrev": "dashboard", "title": "Dashboard" },
            map { "abbrev": "docs", "title": "Documentation" },
            map { "abbrev": "notebook", "title": "Notebook" },
            map { "abbrev": "blog", "title": "Blog" }
        }
    }
}
let $_ :=
    if (util:binary-doc-available("/db/apps/jinks/modules/generator.xqm") or
        doc-available("/db/apps/jinks/modules/generator.xqm")) then
        try {
            let $_ := util:import-module(
                xs:anyURI("http://tei-publisher.com/library/generator"),
                "generator",
                xs:anyURI("/db/apps/jinks/modules/generator.xqm")
            )
            let $_ := util:eval('generator:process(map { "overwrite": () }, $config)', false(),
                    (xs:QName("config"), $jinks-config))
            (: Fix MIME type for .xqm modules — the generator stores them as
             : application/octet-stream but eXist needs application/xquery :)
            return
                for $mod in xmldb:get-child-resources($target || "/modules")
                where ends-with($mod, ".xqm")
                let $path := $target || "/modules/" || $mod
                where util:binary-doc-available($path) and
                      xmldb:get-mime-type(xs:anyURI($path)) != "application/xquery"
                let $content := util:binary-to-string(util:binary-doc($path))
                let $_ := xmldb:remove($target || "/modules", $mod)
                return xmldb:store($target || "/modules", $mod, $content, "application/xquery")
        } catch * {
            util:log("WARN", "docs: Jinks generator failed: " || $err:description)
        }
    else
        util:log("WARN", "docs: Jinks generator not available. Install Jinks and re-deploy.")

return
    util:log("INFO", (
        "documentation-next: compiled xdita.odd, generated XQDoc for ",
        $summary/generated/string(), " of ",
        $summary/total/string(), " modules"
    ))
