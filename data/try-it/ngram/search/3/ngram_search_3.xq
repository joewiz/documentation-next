(: Substring search using the NGram index — no wildcards needed :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
for $person in $data//person[ngram:contains(name, "spring")]
return
    $person/name/string() || " — " || $person/city/string()
