import module namespace bin = "http://expath.org/ns/binary";

(: Pad binary data on the left to a specified size :)
let $data := bin:hex("FF")
let $padded := bin:pad-left($data, 4)
return xs:hexBinary($padded)
