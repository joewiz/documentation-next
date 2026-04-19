(: Extract metadata from binary content using Apache Tika :)
try {
    let $data := util:string-to-binary("Hello, this is a plain text document.")
    return contentextraction:get-metadata($data)
} catch * {
    "contentextraction:get-metadata#1 — extracts metadata (MIME type, encoding, etc.) from binary data using Apache Tika. Error: " || $err:description
}
