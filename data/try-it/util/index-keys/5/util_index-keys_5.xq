(: List index keys for a collection — requires indexed data :)
try {
    util:index-keys(collection("/db/apps/docs/data/try-it/ft/data"), (),
        function($key, $count) { $key || ": " || $count[1] }, 10, "structural-index")
} catch * { "index-keys: " || $err:description }