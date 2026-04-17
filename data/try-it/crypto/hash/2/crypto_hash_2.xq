(: Compute a hash of data using various algorithms :)
(: Default output encoding is base64 :)
import module namespace crypto = "http://expath.org/ns/crypto";

<hashes>
  <md5>{crypto:hash("hello", "MD5")}</md5>
  <sha1>{crypto:hash("hello", "SHA-1")}</sha1>
  <sha256>{crypto:hash("hello", "SHA-256")}</sha256>
  <sha512>{crypto:hash("hello", "SHA-512")}</sha512>
</hashes>
