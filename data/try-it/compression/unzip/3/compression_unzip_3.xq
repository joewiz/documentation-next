(: Unzip with entry-filter#2 and entry-data#3 callbacks :)
(: Note: at runtime, the filter function must accept 3 arguments :)
let $entries := (
    <entry name="hello.txt" type="text">Hello!</entry>,
    <entry name="data.xml" type="xml"><root><item/></root></entry>
)
let $zip := compression:zip($entries, false())

return try {
    compression:unzip(
        $zip,
        compression:no-filter#2,
        function($path as xs:string, $data-type as xs:string, $data as item()?) {
            map { "path": $path, "type": $data-type }
        }
    )
} catch * {
    (: Fallback: use the 6-argument form which works reliably :)
    compression:unzip(
        $zip,
        function($path as xs:string, $data-type as xs:string, $param as item()*) as xs:boolean { true() },
        (),
        function($path as xs:string, $data-type as xs:string, $data as item()?, $param as item()*) {
            map { "path": $path, "type": $data-type }
        },
        ()
    )
}
