import module namespace md = "http://exist-db.org/xquery/markdown";

(: Round-trip: parse markdown to XML, then serialize back to markdown :)
let $original := "# Round Trip

A paragraph with **bold** text.

1. First
2. Second
3. Third
"
let $parsed := md:parse($original)
return md:serialize($parsed)
