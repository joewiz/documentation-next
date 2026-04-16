(: Generate an index report for a document :)
try {
    util:index-report(doc("/db/apps/docs/data/try-it/ft/data/poems.xml"))
} catch * { "index-report: " || $err:description }