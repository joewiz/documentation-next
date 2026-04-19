(: GZip binary data and show the round-trip :)
let $data := util:string-to-binary("Hello, compressed world!")
let $compressed := compression:gzip($data)
let $decompressed := compression:ungzip($compressed)
return map {
    "original": "Hello, compressed world!",
    "compressed": $compressed,
    "decompressed": util:binary-to-string($decompressed)
}
