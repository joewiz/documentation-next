import module namespace bin = "http://expath.org/ns/binary";

(: Concatenate multiple binary values :)
let $hello := bin:encode-string("Hello")
let $space := bin:encode-string(" ")
let $world := bin:encode-string("World")
let $joined := bin:join(($hello, $space, $world))
return bin:decode-string($joined, "UTF-8")
