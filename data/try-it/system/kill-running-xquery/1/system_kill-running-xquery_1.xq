(: List running queries instead of killing them :)
let $queries := system:get-running-xqueries()
return
    if (exists($queries//query)) then
        for $q in $queries//query
        return "ID: " || $q/@id || " — " || substring($q/@sourceKey, 1, 60)
    else "No running queries"
