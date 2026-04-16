(: Search poems for lines containing "road" or "night" :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $line in $data//line[ft:query(., "road OR night")]
let $poem := $line/ancestor::poem/title/string()
return
    $poem || ": " || $line/string()
