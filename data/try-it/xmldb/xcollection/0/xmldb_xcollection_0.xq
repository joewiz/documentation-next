(: xcollection returns the exact collection, no subcollections :)
try { xmldb:xcollection("/db/apps/docs/data") }
catch * { "xcollection: " || $err:description }