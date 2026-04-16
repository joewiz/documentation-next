import module namespace bin = "http://expath.org/ns/binary";

(: Shift binary data left (positive) or right (negative) :)
let $data := bin:hex("01")
return (
    "Original:    " || xs:hexBinary($data),
    "Shift left 4:  " || xs:hexBinary(bin:shift($data, 4)),
    "Shift right 4: " || xs:hexBinary(bin:shift($data, -4))
)
