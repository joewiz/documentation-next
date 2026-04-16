(: Find cities ending with a given suffix :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
for $person in $data//person[ngram:ends-with(city, "eld")]
return
    $person/name || " lives in " || $person/city
