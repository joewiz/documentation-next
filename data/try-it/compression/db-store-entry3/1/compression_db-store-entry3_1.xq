(: Create a db-store callback for unzip#3/untar#3 :)
(: Extracts entries into a database collection :)
let $store-fn := compression:db-store-entry3("/db/apps/docs/data/try-it/compression/data")
return "compression:db-store-entry3#1 — returns a function($path, $data-type, $data) for storing extracted entries into a database collection"
