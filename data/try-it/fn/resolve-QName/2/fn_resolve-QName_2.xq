let $value := "hello"
let $element := <element>text</element>
return
    resolve-QName($value, $element)