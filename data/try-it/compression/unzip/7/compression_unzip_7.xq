(: Unzip with filter params, data params, and explicit encoding :)
let $entries :=
    <entry name="note.txt" type="text">Content with encoding</entry>
let $zip := compression:zip($entries, false())

return compression:unzip(
    $zip,
    compression:no-filter#3,
    (),
    function($path as xs:string, $data-type as xs:string, $data as item()?, $param as item()*) {
        map { "path": $path, "type": $data-type }
    },
    (),
    "UTF-8"
)
