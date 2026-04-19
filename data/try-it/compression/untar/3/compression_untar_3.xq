(: Extract entries from a tar archive using filter and data callbacks :)
(: Note: tar creation has a known header-size bug; this demonstrates the API :)
try {
    let $entries := (
        <entry name="file1.txt" type="text">First file</entry>,
        <entry name="file2.txt" type="text">Second file</entry>
    )
    let $tar := compression:tar($entries, false())
    return compression:untar(
        $tar,
        compression:no-filter#2,
        function($path as xs:string, $data-type as xs:string, $data as item()?) {
            map { "path": $path, "type": $data-type }
        }
    )
} catch * {
    "compression:untar#3 — extracts tar entries using filter and data callback functions. Error: " || $err:description
}
