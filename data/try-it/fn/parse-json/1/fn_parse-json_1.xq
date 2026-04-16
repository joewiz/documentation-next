let $value := '{"database":"eXist-db","version":7,"active":true}'
return
    parse-json($value)?database