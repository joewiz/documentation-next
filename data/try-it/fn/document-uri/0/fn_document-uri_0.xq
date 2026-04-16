(: document-uri#0 needs a context node; using #1 instead :)
let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
return
    document-uri($doc)