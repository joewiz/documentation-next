(: Phrase search on poem lines :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $hit in $data//line[ft:query(., '"good night"')]
return
    $hit/ancestor::poem/title || ": " || normalize-space($hit)
