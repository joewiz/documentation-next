(: Highlight ngram matches in text :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
for $person in $data//person[ngram:contains(description, "data")]
return
    <match name="{$person/name}">
        {ngram:add-match($person/description)}
    </match>
