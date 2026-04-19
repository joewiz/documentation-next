(: Raw deflate without zlib header/checksum (RFC 1951) :)
let $data := util:string-to-binary("Raw deflate data!")
let $zlib := compression:deflate($data)
let $raw := compression:deflate($data, true())
return map {
    "zlib-wrapped": $zlib,
    "raw-deflate": $raw
}
