xquery version "3.1";

(:~
 : Function documentation module.
 :
 : Handles XQDoc generation from module introspection, categorization,
 : search, and data retrieval for Jinks templates.
 :
 : Generation logic ported from eXist-db/function-documentation generate.xqm.
 : Query/categorization logic ported from app.xqm.
 :)
module namespace fundocs = "http://exist-db.org/apps/docs/fundocs";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace dbutil = "http://exist-db.org/apps/docs/dbutil"
    at "dbutil.xqm";

declare namespace xqdoc = "http://www.xqdoc.org/1.0";

(: ========================= :)
(:  XQDoc Generation         :)
(: ========================= :)

(:~
 : Generate XQDoc XML for all discoverable modules and store in the database.
 :
 : Scans three sources:
 :   1. Mapped modules (external libraries configured in eXist)
 :   2. Registered modules (built-in/extension functions)
 :   3. Stored modules (user XQuery modules in /db)
 :
 : @return summary element with total/generated counts
 :)
declare function fundocs:generate-all() {
    let $modules := (
        fundocs:load-mapped-modules(),
        fundocs:load-registered-modules(),
        fundocs:load-stored-modules()
    )
    let $with-definitions := filter($modules, function($m) { exists($m?2) })
    let $generated-count := count($with-definitions)
    let $_ := for-each($with-definitions, fundocs:store-xqdoc#1)
    return
        <summary>
            <total>{count($modules)}</total>
            <generated>{$generated-count}</generated>
        </summary>
};

declare %private function fundocs:load-mapped-modules() as array(*)* {
    for $path in util:mapped-modules()
    let $uri := xs:anyURI($path)
    return fundocs:safe-inspect($uri, inspect:inspect-module-uri#1)
};

declare %private function fundocs:load-registered-modules() as array(*)* {
    for $path in util:registered-modules()
    let $uri := xs:anyURI($path)
    return fundocs:safe-inspect($uri, inspect:inspect-module-uri#1)
};

declare %private function fundocs:load-stored-modules() as array(*)* {
    for $uri in dbutil:find-by-mimetype(xs:anyURI("/db"), "application/xquery")
    return fundocs:safe-inspect($uri, inspect:inspect-module#1)
};

declare %private function fundocs:safe-inspect(
    $moduleUri as xs:anyURI,
    $inspect as function(xs:anyURI) as element(module)?
) as array(*)? {
    try {
        [$moduleUri, $inspect($moduleUri)]
    } catch * {
        util:log("DEBUG", (
            "Could not compile function documentation for: ",
            $moduleUri, " (", $err:code, ") ", $err:description
        ))
    }
};

declare %private function fundocs:store-xqdoc($module-info as array(*)) {
    let $filename := concat(util:hash($module-info?1, "md5"), ".xml")
    let $xqdoc := fundocs:module-to-xqdoc($module-info?2)
    return
        xmldb:store($config:functions-data, $filename, $xqdoc)
            => xs:anyURI()
            => sm:chmod("rw-rw-r--")
};

(: ========================= :)
(:  XQDoc XML Construction   :)
(: ========================= :)

declare %private function fundocs:module-to-xqdoc(
    $module as element(module)
) as element(xqdoc:xqdoc) {
    let $prefix := fundocs:default-prefix($module/@uri, $module/@prefix)
    return
    <xqdoc:xqdoc xmlns:xqdoc="http://www.xqdoc.org/1.0">
        <xqdoc:control>
            <xqdoc:date>{current-dateTime()}</xqdoc:date>
            <xqdoc:location>{$module/@location/string()}</xqdoc:location>
            <xqdoc:site-url>functions/{$prefix}/</xqdoc:site-url>
        </xqdoc:control>
        <xqdoc:module type="library">
            <xqdoc:uri>{$module/@uri/string()}</xqdoc:uri>
            <xqdoc:name>{$prefix}</xqdoc:name>
            <xqdoc:comment>
                <xqdoc:description>{$module/description/string()}</xqdoc:description>
                {
                    for $el in $module/(version, author, see, since)
                    return
                        element { QName("http://www.xqdoc.org/1.0", "xqdoc:" || local-name($el)) } {
                            $el/string()
                        }
                }
            </xqdoc:comment>
        </xqdoc:module>
        <xqdoc:variables>
        {
            for $variable in $module/variable
            return
                <xqdoc:variable>
                    <xqdoc:name>{$variable/@name/string()}</xqdoc:name>
                </xqdoc:variable>
        }
        </xqdoc:variables>
        <xqdoc:functions>
        {
            for $function in $module/function
            return fundocs:function-to-xqdoc($function)
        }
        </xqdoc:functions>
    </xqdoc:xqdoc>
};

declare %private function fundocs:function-to-xqdoc(
    $function as element(function)
) as element(xqdoc:function) {
    <xqdoc:function>
        <xqdoc:name>{$function/@name/string()}</xqdoc:name>
        <xqdoc:signature>{fundocs:signature($function)}</xqdoc:signature>
        <xqdoc:parameters>
        {
            for $arg in $function/argument
            return
                <xqdoc:parameter>
                    <xqdoc:name>{"$" || $arg/@var}</xqdoc:name>
                    <xqdoc:type occurrence="{fundocs:cardinality($arg/@cardinality)}">
                        {$arg/@type/string()}
                    </xqdoc:type>
                </xqdoc:parameter>
        }
        </xqdoc:parameters>
        <xqdoc:arity>{count($function/argument)}</xqdoc:arity>
        <xqdoc:return>
            <xqdoc:type occurrence="{fundocs:cardinality($function/returns/@cardinality)}">
                {$function/returns/@type/string()}
            </xqdoc:type>
        </xqdoc:return>
        {
            if (empty($function/annotation)) then ()
            else
                <xqdoc:annotations>
                {
                    for $annotation in $function/annotation
                    return
                        <xqdoc:annotation>
                            <xqdoc:name>{$annotation/@name/string()}</xqdoc:name>
                            <xqdoc:literal>{
                                if (empty($annotation/value)) then ()
                                else "(" || string-join($annotation/value, ", ") || ")"
                            }</xqdoc:literal>
                        </xqdoc:annotation>
                }
                </xqdoc:annotations>
        }
        <xqdoc:comment>
            <xqdoc:description>{$function/description/string()}</xqdoc:description>
            {
                for $argument in $function/argument
                return
                    <xqdoc:param>{"$" || $argument/@var || " " || $argument/text()}</xqdoc:param>
            }
            <xqdoc:return>
            {
                $function/returns/@type/string() ||
                fundocs:cardinality($function/returns/@cardinality)
            }{
                if (empty($function/returns/text())) then ()
                else " : " || $function/returns/text()
            }
            </xqdoc:return>
            {
                if (empty($function/deprecated)) then ()
                else <xqdoc:deprecated>{$function/deprecated/string()}</xqdoc:deprecated>
            }
            {
                for $el in $function/(author, version, see, since)
                return
                    element { QName("http://www.xqdoc.org/1.0", "xqdoc:" || local-name($el)) } {
                        $el/string()
                    }
            }
        </xqdoc:comment>
    </xqdoc:function>
};

(:~
 : Assign a default prefix for modules that report empty prefixes.
 : W3C built-in modules often have no declared prefix.
 :)
declare %private function fundocs:default-prefix(
    $uri as xs:string?,
    $prefix as xs:string?
) as xs:string {
    if (normalize-space($prefix) != "") then
        string($prefix)
    else
        switch (string($uri))
            case "http://www.w3.org/2005/xpath-functions" return "fn"
            case "http://www.w3.org/2005/xpath-functions/math" return "math"
            case "http://www.w3.org/2005/xpath-functions/map" return "map"
            case "http://www.w3.org/2005/xpath-functions/array" return "array"
            default return
                (: Extract last path segment as fallback :)
                let $segments := tokenize(string($uri), "/")
                return ($segments[last()][. != ""], "unknown")[1]
};

declare %private function fundocs:cardinality($cardinality as xs:string) as xs:string? {
    switch ($cardinality)
        case "zero or one" return "?"
        case "zero or more" return "*"
        case "one or more" return "+"
        default return ()
};

declare %private function fundocs:signature(
    $function as element(function)
) as xs:string {
    let $name := $function/@name/string()
    (: Prepend module prefix if the name doesn't already contain one :)
    let $qualified-name :=
        if (contains($name, ':')) then $name
        else
            let $module := $function/ancestor::module
            let $prefix := fundocs:default-prefix($module/@uri, $module/@prefix)
            return
                if ($prefix != "" and $prefix != "unknown") then
                    $prefix || ":" || $name
                else $name
    let $arguments :=
        for $argument in $function/argument
        return
            "$" || $argument/@var || " as " ||
            $argument/@type || fundocs:cardinality($argument/@cardinality)
    return
        $qualified-name || "(" || string-join($arguments, ", ") || ")" ||
        " as " || $function/returns/@type ||
        fundocs:cardinality($function/returns/@cardinality)
};

(: ========================= :)
(:  Module Categorization    :)
(: ========================= :)

(:~
 : Categorize a module as w3c, extension, or application.
 :)
declare function fundocs:categorize(
    $uri as xs:string,
    $location as xs:string?
) as xs:string {
    if (starts-with($uri, "http://www.w3.org")) then
        "w3c"
    else if (starts-with($location, "/db")) then
        "application"
    else
        "extension"
};

(:~
 : Check if a function belongs to a W3C built-in module.
 :)
declare function fundocs:is-builtin($function-name as xs:string) as xs:boolean {
    not(contains($function-name, ':')) or
    starts-with($function-name, 'fn:') or
    starts-with($function-name, 'math:') or
    starts-with($function-name, 'map:') or
    starts-with($function-name, 'array:')
};

(: ========================= :)
(:  Data Retrieval (for      :)
(:  Jinks template context)  :)
(: ========================= :)

(: All stored XQDoc data :)
declare %private variable $fundocs:data :=
    collection($config:functions-data)/xqdoc:xqdoc;

(:~
 : List all modules grouped by category.
 :
 : @param $category optional filter: "w3c", "extension", "application", or ()
 : @return array of category maps, each containing title and modules array
 :)
declare function fundocs:list-modules($category as xs:string?) as array(*) {
    let $categories := map {
        "w3c": "W3C XPath/XQuery Functions",
        "extension": "eXist-db Extension Functions",
        "application": "Application Modules"
    }
    let $category-order := ("w3c", "extension", "application")
    return array {
        for $cat in $category-order
        where empty($category) or $category = "all" or $category = $cat
        let $modules :=
            for $module in $fundocs:data
            let $uri := $module/xqdoc:module/xqdoc:uri/string()
            let $location := $module/xqdoc:control/xqdoc:location/string()
            where fundocs:categorize($uri, $location) = $cat
            let $prefix := $module/xqdoc:module/xqdoc:name/string()
            order by ($prefix, $uri)[1]
            return map {
                "prefix": $prefix,
                "uri": $uri,
                "location": $location,
                "description": $module/xqdoc:module/xqdoc:comment/xqdoc:description/string(),
                "function-count": count($module//xqdoc:function),
                "category": $cat
            }
        where exists($modules)
        return map {
            "id": $cat,
            "title": $categories($cat),
            "modules": array { $modules }
        }
    }
};

(:~
 : Get a single module's details by prefix.
 :
 : If multiple modules share a prefix, returns an array of all matches
 : (for disambiguation).
 :
 : @param $prefix the module namespace prefix
 : @return map with module metadata and functions array
 :)
declare function fundocs:get-module($prefix as xs:string) as map(*)* {
    for $module in $fundocs:data[xqdoc:module/xqdoc:name = $prefix]
    let $uri := $module/xqdoc:module/xqdoc:uri/string()
    let $location := $module/xqdoc:control/xqdoc:location/string()
    return map {
        "prefix": $prefix,
        "uri": $uri,
        "location": $location,
        "description": $module/xqdoc:module/xqdoc:comment/xqdoc:description/string(),
        "metadata": map:merge(
            for $meta in $module/xqdoc:module/xqdoc:comment/(xqdoc:author|xqdoc:version|xqdoc:since|xqdoc:see)
            return map { local-name($meta): $meta/string() }
        ),
        "category": fundocs:categorize($uri, $location),
        "functions": array {
            for $function in $module//xqdoc:function
            order by $function/xqdoc:name, xs:integer($function/xqdoc:arity)
            return fundocs:function-to-map($function)
        }
    }
};

(:~
 : Get a module by its full namespace URI (for disambiguation fallback).
 :)
declare function fundocs:get-module-by-uri(
    $uri as xs:string,
    $location as xs:string?
) as map(*)? {
    let $modules :=
        if ($location) then
            $fundocs:data
                [xqdoc:module/xqdoc:uri eq $uri]
                [xqdoc:control/xqdoc:location eq $location]
        else
            $fundocs:data[xqdoc:module/xqdoc:uri eq $uri]
    for $module in $modules
    let $prefix := $module/xqdoc:module/xqdoc:name/string()
    return map {
        "prefix": $prefix,
        "uri": $uri,
        "location": $module/xqdoc:control/xqdoc:location/string(),
        "description": $module/xqdoc:module/xqdoc:comment/xqdoc:description/string(),
        "metadata": map:merge(
            for $meta in $module/xqdoc:module/xqdoc:comment/(xqdoc:author|xqdoc:version|xqdoc:since|xqdoc:see)
            return map { local-name($meta): $meta/string() }
        ),
        "category": fundocs:categorize(
            $uri,
            $module/xqdoc:control/xqdoc:location/string()
        ),
        "functions": array {
            for $function in $module//xqdoc:function
            order by $function/xqdoc:name, xs:integer($function/xqdoc:arity)
            return fundocs:function-to-map($function)
        }
    }
};

(:~
 : Get details for a specific function (all arities) by prefix and local name.
 :
 : @param $prefix the module prefix
 : @param $local-name the function local name (without prefix)
 : @return sequence of function maps
 :)
declare function fundocs:get-function(
    $prefix as xs:string,
    $local-name as xs:string
) as map(*)* {
    let $full-name := $prefix || ":" || $local-name
    for $module in $fundocs:data[xqdoc:module/xqdoc:name = $prefix]
    let $functions := $module//xqdoc:function[xqdoc:name = ($full-name, $local-name)]
    for $function in $functions
    order by xs:integer($function/xqdoc:arity)
    return fundocs:function-to-map($function)
};

(:~
 : Search function documentation using Lucene full-text.
 :
 : @param $q the search query
 : @return array of result maps
 :)
declare function fundocs:search($q as xs:string) as array(*) {
    if ($q = "") then
        array {}
    else
        (: Preprocess the query to handle XQuery function name syntax (prefix:name).
           KeywordAnalyzer fields (name, signature, uri) index the full string as one
           token, so we escape the colon: util:eval → util\:eval.
           StandardAnalyzer fields (description) split on punctuation, so we convert
           to a phrase search: util:eval → "util eval". :)
        let $kw-q   := replace($q, '(\w+):(\w+)', '$1\\:$2')
        let $text-q := replace($q, '(\w+):(\w+)', '"$1 $2"')
        let $hits := (
            (: Search function names (KeywordAnalyzer — colon is part of the token) :)
            $fundocs:data//xqdoc:function[ft:query(xqdoc:name, $kw-q)],
            (: Search signatures (KeywordAnalyzer) :)
            $fundocs:data//xqdoc:function[ft:query(xqdoc:signature, $kw-q)],
            (: Search descriptions (StandardAnalyzer — use phrase search) :)
            $fundocs:data//xqdoc:function
                [ft:query(xqdoc:comment/xqdoc:description, $text-q)],
            (: Search module URIs (KeywordAnalyzer) :)
            $fundocs:data[ft:query(xqdoc:module/xqdoc:uri, $kw-q)]//xqdoc:function,
            (: Search module prefix names (KeywordAnalyzer — exact match on short names) :)
            $fundocs:data[xqdoc:module/xqdoc:name = $q]//xqdoc:function
        )
        let $unique := distinct-values($hits ! generate-id(.))
        return array {
            for $id in $unique
            let $function := $hits[generate-id(.) = $id][1]
            let $module := $function/ancestor::xqdoc:xqdoc
            let $prefix := $module/xqdoc:module/xqdoc:name/string()
            let $uri := $module/xqdoc:module/xqdoc:uri/string()
            let $location := $module/xqdoc:control/xqdoc:location/string()
            let $name := $function/xqdoc:name/string()
            let $local-name :=
                if (contains($name, ':')) then substring-after($name, ':')
                else $name
            order by ft:score($function) descending
            return map {
                "name": $name,
                "prefix": $prefix,
                "local-name": $local-name,
                "arity": $function/xqdoc:arity/string(),
                "signature": $function/xqdoc:signature/string(),
                "description": substring(
                    $function/xqdoc:comment/xqdoc:description/string(), 1, 200
                ),
                "module-uri": $uri,
                "category": fundocs:categorize($uri, $location),
                "type": "function"
            }
        }
};

(: ========================= :)
(:  Internal helpers         :)
(: ========================= :)

(:~
 : Convert a xqdoc:function element to a map for template rendering.
 :)
declare %private function fundocs:function-to-map(
    $function as element(xqdoc:function)
) as map(*) {
    let $name := $function/xqdoc:name/string()
    let $comment := $function/xqdoc:comment
    let $local-name :=
        if (contains($name, ':')) then substring-after($name, ':')
        else $name
    let $deprecated := exists($comment/xqdoc:deprecated)
    return map {
        "name": $name,
        "local-name": $local-name,
        "arity": xs:integer($function/xqdoc:arity),
        "signature": $function/xqdoc:signature/string(),
        "description": $comment/xqdoc:description/string(),
        "is-builtin": fundocs:is-builtin($name),
        "is-deprecated": $deprecated,
        "deprecated-note": $comment/xqdoc:deprecated/string(),
        "function-class": if ($deprecated) then "function deprecated" else "function",
        "show-deprecated-badge": $deprecated,
        "parameters": array {
            for $param in $function/xqdoc:parameters/xqdoc:parameter
            return map {
                "name": $param/xqdoc:name/string(),
                "type": $param/xqdoc:type/string(),
                "occurrence": $param/xqdoc:type/@occurrence/string(),
                "description":
                    let $var-name := $param/xqdoc:name/string()
                    let $param-doc := head(
                        $comment/xqdoc:param
                            [starts-with(normalize-space(.), $var-name)]
                    )
                    return
                        if ($param-doc) then
                            normalize-space(
                                substring-after(normalize-space($param-doc), $var-name)
                            )
                        else ""
            }
        },
        "return": map {
            "type": $function/xqdoc:return/xqdoc:type/string(),
            "occurrence": $function/xqdoc:return/xqdoc:type/@occurrence/string(),
            "description": $comment/xqdoc:return/string()
        },
        "annotations": array {
            for $ann in $function/xqdoc:annotations/xqdoc:annotation
            return map {
                "name": $ann/xqdoc:name/string(),
                "literal": $ann/xqdoc:literal/string()
            }
        },
        "metadata": map:merge((
            if ($comment/xqdoc:author) then
                map { "author": string-join($comment/xqdoc:author, ", ") }
            else (),
            if ($comment/xqdoc:version) then
                map { "version": $comment/xqdoc:version/string() }
            else (),
            if ($comment/xqdoc:since) then
                map { "since": $comment/xqdoc:since/string() }
            else (),
            if ($comment/xqdoc:see) then
                map { "see": array { $comment/xqdoc:see/string() } }
            else ()
        ))
    }
};
