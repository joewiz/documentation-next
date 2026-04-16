try { xmldb:clear-lock("/db/apps/docs/data/try-it/ft/data", "poems.xml") }
catch * { "No lock to clear" }