(: Search glossary using field-based queries :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $opts := map { "fields": ("term", "definition") }
for $entry in $data//entry[ft:query(., "index*", $opts)]
return
    <match category="{$entry/@category}">
        <term>{$entry/term/string()}</term>
        <score>{ft:score($entry)}</score>
    </match>
