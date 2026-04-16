let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
let $first-node := $doc//title[1]
let $id := util:node-id($first-node)
return util:node-by-id($doc, $id)