(: ft:has-index checks if a collection has a Lucene full-text index :)
try {
    ft:has-index("/db/apps/docs/data/try-it/ft/data/poems.xml")
} catch * {
    "ft:has-index: " || $err:description
}