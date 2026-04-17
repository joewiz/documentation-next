(: Generate an XML digital signature for a document :)
(: Uses a generated RSA key pair; returns the signed document :)
import module namespace crypto = "http://expath.org/ns/crypto";

let $doc :=
  <order id="12345">
    <item>Widget</item>
    <quantity>10</quantity>
    <price>29.99</price>
  </order>
return
  crypto:generate-signature(
    $doc,
    "exclusive",
    "SHA256",
    "RSA_SHA256",
    "dsig",
    "enveloped"
  )
