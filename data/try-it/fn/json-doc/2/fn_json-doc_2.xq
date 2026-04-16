let $source := "/db/apps/docs/config.json"
let $options := map { "liberal": true() }
return
    json-doc($source, $options)?abbrev