import module namespace exfile = "http://expath.org/ns/file";
import module namespace bin = "http://expath.org/ns/binary";

(: Read binary data from a file :)
let $f := exfile:create-temp-file("tryit", ".bin")
let $_ := exfile:write-binary($f, bin:hex("DEADBEEF"))
let $data := exfile:read-binary($f)
let $_ := exfile:delete($f)
return xs:hexBinary($data)
