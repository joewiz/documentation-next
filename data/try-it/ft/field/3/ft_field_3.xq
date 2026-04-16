(: Retrieve a typed field value :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $opts := map { "fields": "category" }
for $entry in $data//entry[ft:query(., "index*", $opts)]
return
    ft:field($entry, "category", "xs:string") || " — " ||
    $entry/term/string()
