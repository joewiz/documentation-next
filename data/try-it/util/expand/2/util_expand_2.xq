let $node := <item>value</item>
let $serialization-parameters := "hello"
return
    util:expand($node, $serialization-parameters)