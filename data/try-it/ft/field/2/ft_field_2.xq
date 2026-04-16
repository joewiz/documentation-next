(: Retrieve field values from indexed glossary entries :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $opts := map { "fields": ("term", "definition") }
for $entry in $data//entry[ft:query(., "query OR search", $opts)]
return
    ft:field($entry, "term") || ": " ||
    substring(ft:field($entry, "definition"), 1, 80) || "..."
