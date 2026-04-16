(: Wildcard search — ? matches one char, * matches any :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
for $person in $data//person[ngram:wildcard-contains(email, "*@example.org")]
return
    $person/name || ": " || $person/email
