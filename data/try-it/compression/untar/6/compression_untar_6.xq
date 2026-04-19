(: Untar with filter params and data params for selective extraction :)
(: Note: tar creation has a known header-size bug; this demonstrates the API :)
try {
    let $entries := (
        <entry name="keep.txt" type="text">Keep</entry>,
        <entry name="skip.tmp" type="text">Skip</entry>
    )
    let $tar := compression:tar($entries, false())
    return compression:untar(
        $tar,
        function($path as xs:string, $data-type as xs:string, $param as item()*) as xs:boolean {
            not(ends-with($path, ".tmp"))
        },
        (),
        function($path as xs:string, $data-type as xs:string, $data as item()?, $param as item()*) {
            $path
        },
        ()
    )
} catch * {
    "compression:untar#6 — like untar#3 but with additional filter and data parameters. Error: " || $err:description
}
