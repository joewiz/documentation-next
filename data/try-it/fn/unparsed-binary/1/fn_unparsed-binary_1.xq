(: unparsed-binary loads binary content :)
try {
    let $data := unparsed-binary("/db/apps/docs/resources/favicon.ico")
    return "Loaded " || string-length(string($data)) || " base64 chars"
} catch * {
    "unparsed-binary: " || $err:description
}