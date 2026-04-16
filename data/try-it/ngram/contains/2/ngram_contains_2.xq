(: Substring search — finds "spring" anywhere in the name :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
for $person in $data//person[ngram:contains(name, "spring")]
return
    $person/name || " — " || $person/city
