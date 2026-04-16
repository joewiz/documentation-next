(: Get facet counts from glossary entries by category :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $hits := $data//entry[ft:query(., "*")]
let $facets := ft:facets($hits, "category", ())
return
    for $cat in map:keys($facets)
    order by $facets($cat) descending
    return
        $cat || ": " || $facets($cat) || " entries"
