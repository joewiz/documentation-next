let $name := xs:QName("fn:concat")
let $arity := 42
return
    function-lookup($name, $arity)