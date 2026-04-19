(: Deflate data using zlib format (RFC 1950) :)
let $data := util:string-to-binary("Deflate this string!")
let $deflated := compression:deflate($data)
return map {
    "original": util:binary-to-string($data),
    "deflated": $deflated
}
