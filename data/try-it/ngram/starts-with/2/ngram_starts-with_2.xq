(: Find names that start with a given prefix :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
for $person in $data//person[ngram:starts-with(name, "Ch")]
return
    $person/name || " (" || $person/email || ")"
