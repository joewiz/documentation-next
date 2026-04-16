import module namespace bin = "http://expath.org/ns/binary";

(: Pad binary data on the left with a specific byte :)
let $data := bin:hex("FF")
let $padded := bin:pad-left($data, 4, 170)
return xs:hexBinary($padded)
