try { count(xmldb:xcollection("/db/apps/docs/data/try-it/ft/data")/*) }
catch * { "xcollection: " || $err:description }