let $value := '{"database":"eXist-db","version":7}'
let $options := map { "liberal": true() }
return
    parse-json($value, $options)?database