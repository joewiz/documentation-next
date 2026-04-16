(: Load and query an XML document from the database :)
let $doc := doc("/db/apps/docs/data/articles/xmldb/xmldb.xml")
return (
    "Title: " || $doc//title[1],
    "Sections: " || count($doc//section)
)
