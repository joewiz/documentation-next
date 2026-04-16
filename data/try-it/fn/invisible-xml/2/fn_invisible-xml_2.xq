(: invisible-xml with options :)
let $grammar := "greeting: 'hello' ."
let $options := map {}
return
    invisible-xml($grammar, $options)("hello")