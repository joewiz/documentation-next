try {
    util:index-key-documents(collection("/db/apps/docs/data/try-it/ft/data")//line, "road", "lucene-index")
} catch * { "Error: " || $err:description }