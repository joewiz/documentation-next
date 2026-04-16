(: Load and query an XML document from the database :)
let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
return (
    "Poems: " || count($doc//poem),
    for $title in $doc//title return "  - " || $title
)