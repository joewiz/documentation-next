let $input := <doc><greeting>Hello</greeting></doc>
let $options := map { "method": "xml", "indent": true(), "omit-xml-declaration": true() }
return
    serialize($input, $options)