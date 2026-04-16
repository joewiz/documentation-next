let $function-name := xs:QName("fn:concat")
let $arity := 42
return
    system:function-available($function-name, $arity)