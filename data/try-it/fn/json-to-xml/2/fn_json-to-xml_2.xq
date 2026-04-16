let $value := '{"name":"eXist","version":7}'
let $options := map { "liberal": true() }
return
    json-to-xml($value, $options)