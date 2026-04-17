(: Encrypt data using symmetric AES encryption :)
(: Key must be exactly 16 bytes for AES :)
import module namespace crypto = "http://expath.org/ns/crypto";

let $plaintext := "Secret message from eXist-db"
let $key := "0123456789abcdef"
let $encrypted := crypto:encrypt($plaintext, "symmetric", $key, "AES")
return
  <encryption>
    <plaintext>{$plaintext}</plaintext>
    <encrypted>{$encrypted}</encrypted>
    <decrypted>{crypto:decrypt($encrypted, "symmetric", $key, "AES")}</decrypted>
  </encryption>
