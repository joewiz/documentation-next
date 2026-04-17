(: Calculate HMAC (keyed-hash message authentication code) :)
import module namespace crypto = "http://expath.org/ns/crypto";

let $data := "important message"
let $key := "my-secret-key"
return
  <hmacs>
    <sha256>{crypto:hmac($data, $key, "SHA256")}</sha256>
    <sha512>{crypto:hmac($data, $key, "SHA512")}</sha512>
  </hmacs>
