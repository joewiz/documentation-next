try {
    util:index-keys-by-qname(xs:QName("line"), collection("/db/apps/docs/data/try-it/ft/data"), (),
        function($key, $count) { $key || ": " || $count[1] }, 10)
} catch * { "Error: " || $err:description }