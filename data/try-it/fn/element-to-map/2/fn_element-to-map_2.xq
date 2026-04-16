let $element := <element>text</element>
let $options := map { "a": 1, "b": 2 }
return
    element-to-map($element, $options)