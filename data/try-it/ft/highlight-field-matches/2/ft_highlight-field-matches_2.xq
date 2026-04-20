(: Highlight matching terms in search results :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $entry in $data//entry[ft:query(., "fuzzy", map{"fields": ("definition")})]
return
    ft:highlight-field-matches($entry, "definition")