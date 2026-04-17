(: Decrypt data that was encrypted with crypto:encrypt :)
(: The encrypted data includes the IV prepended to the ciphertext :)
import module namespace crypto = "http://expath.org/ns/crypto";

let $key := "0123456789abcdef"
let $original := "Round-trip decryption test"
let $encrypted := crypto:encrypt($original, "symmetric", $key, "AES")
let $decrypted := crypto:decrypt($encrypted, "symmetric", $key, "AES")
return
  <result>
    <original>{$original}</original>
    <decrypted>{$decrypted}</decrypted>
    <match>{$original eq $decrypted}</match>
  </result>
