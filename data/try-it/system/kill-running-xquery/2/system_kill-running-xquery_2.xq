(: List running queries with wait time :)
let $queries := system:get-running-xqueries()
return
    if (exists($queries//query)) then
        for $q in $queries//query
        return "ID: " || $q/@id || " elapsed: " || $q/@elapsed
    else "No running queries to manage"
