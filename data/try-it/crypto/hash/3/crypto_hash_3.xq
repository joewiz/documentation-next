(: Compute a hash with explicit output encoding :)
import module namespace crypto = "http://expath.org/ns/crypto";

<hashes algorithm="SHA-256">
  <base64>{crypto:hash("hello", "SHA-256", "base64")}</base64>
  <hex>{crypto:hash("hello", "SHA-256", "hex")}</hex>
</hashes>
