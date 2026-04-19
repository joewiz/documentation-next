(: Unzip with filter params and data params for selective extraction :)
let $entries := (
    <entry name="include.txt" type="text">Keep this</entry>,
    <entry name="skip.log" type="text">Skip this</entry>,
    <entry name="include.xml" type="xml"><data/></entry>
)
let $zip := compression:zip($entries, false())

(: Only extract entries whose names do not end in .log :)
return compression:unzip(
    $zip,
    function($path as xs:string, $data-type as xs:string, $param as item()*) as xs:boolean {
        not(ends-with($path, ".log"))
    },
    (),
    function($path as xs:string, $data-type as xs:string, $data as item()?, $param as item()*) {
        $path
    },
    ()
)
