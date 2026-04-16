let $value := "hello"
let $element := <element>text</element>
return
    namespace-uri-for-prefix($value, $element)