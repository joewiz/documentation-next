(: Calculate HMAC with explicit output encoding :)
import module namespace crypto = "http://expath.org/ns/crypto";

let $data := "important message"
let $key := "my-secret-key"
return
  <hmac algorithm="SHA256">
    <base64>{crypto:hmac($data, $key, "SHA256", "base64")}</base64>
    <hex>{crypto:hmac($data, $key, "SHA256", "hex")}</hex>
  </hmac>
