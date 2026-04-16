import module namespace bin = "http://expath.org/ns/binary";

(: Pad binary data on the right to a specified size :)
let $data := bin:hex("FF")
let $padded := bin:pad-right($data, 4)
return xs:hexBinary($padded)
