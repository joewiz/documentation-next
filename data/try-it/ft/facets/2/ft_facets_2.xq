(: Get facet counts — requires field-based index with facets :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $hits := $data//entry[ft:query(., "index*")]
return
    for $entry in $hits
    return $entry/term/string() || " (" || $entry/@category || ")"