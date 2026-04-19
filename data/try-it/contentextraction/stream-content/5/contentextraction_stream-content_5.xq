(: Stream extracted content through a callback function :)
let $text := util:string-to-binary("Streaming extraction example with callback processing.")
return contentextraction:stream-content(
    $text,
    "//text()",
    function($node as node(), $userData as item()*, $retValue as item()*) {
        ($retValue, string($node))
    },
    (),
    ()
)
