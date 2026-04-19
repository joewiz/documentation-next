(: Create a db-store callback for unzip#6/untar#6 :)
(: Extracts entries into a database collection, with extra params :)
let $store-fn := compression:db-store-entry4("/db/apps/docs/data/try-it/compression/data")
return "compression:db-store-entry4#1 — returns a function($path, $data-type, $data, $param) for storing extracted entries into a database collection"
