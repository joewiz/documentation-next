(: Untar with filter params, data params, and explicit encoding :)
(: Note: tar creation has a known header-size bug; this demonstrates the API :)
try {
    let $entries :=
        <entry name="note.txt" type="text">Encoded content</entry>
    let $tar := compression:tar($entries, false())
    return compression:untar(
        $tar,
        compression:no-filter#3,
        (),
        function($path as xs:string, $data-type as xs:string, $data as item()?, $param as item()*) {
            map { "path": $path, "type": $data-type }
        },
        (),
        "UTF-8"
    )
} catch * {
    "compression:untar#7 — like untar#6 but with explicit encoding for filenames. Error: " || $err:description
}
