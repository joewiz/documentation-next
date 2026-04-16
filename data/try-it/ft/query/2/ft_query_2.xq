let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $line in $data//line[ft:query(., "road OR night")]
return
    $line/ancestor::poem/title || ": " || $line
