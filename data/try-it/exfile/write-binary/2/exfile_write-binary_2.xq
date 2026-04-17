import module namespace exfile = "http://expath.org/ns/file";
import module namespace bin = "http://expath.org/ns/binary";

(: Write binary data to a file :)
let $f := exfile:create-temp-file("tryit", ".bin")
let $data := bin:encode-string("Binary content!")
let $_ := exfile:write-binary($f, $data)
let $read := exfile:read-binary($f)
let $_ := exfile:delete($f)
return bin:decode-string($read, "UTF-8")
