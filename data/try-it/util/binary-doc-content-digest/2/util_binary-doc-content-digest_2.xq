let $binary-resource := "hello"
let $algorithm := "hello"
return
    util:binary-doc-content-digest($binary-resource, $algorithm)