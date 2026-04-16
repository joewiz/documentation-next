(: Check which collections have a Lucene full-text index :)
for $path in (
    "/db/apps/docs/data/try-it/ft/data",
    "/db/apps/docs/data/try-it/ngram/data",
    "/db/apps/docs/data/articles"
)
return
    $path || ": " || (if (ft:has-index($path)) then "indexed" else "no index")
