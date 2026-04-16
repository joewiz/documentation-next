import module namespace bin = "http://expath.org/ns/binary";

(: Insert binary data at a specific position :)
let $original := bin:encode-string("Hllo")
let $insert := bin:encode-string("e")
let $result := bin:insert-before($original, 1, $insert)
return bin:decode-string($result, "UTF-8")
