try { xmldb:store-files-from-pattern("/db/apps/docs/data/try-it", "/tmp", "*.nonexistent") }
catch * { "store-files-from-pattern: no matching files (expected)" }