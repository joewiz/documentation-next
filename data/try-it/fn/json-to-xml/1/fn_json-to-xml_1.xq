let $value := '{"name":"eXist","version":7,"features":["XQuery","XSLT"]}'
return
    json-to-xml($value)