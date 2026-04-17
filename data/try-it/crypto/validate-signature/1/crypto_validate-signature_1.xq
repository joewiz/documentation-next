(: Validate an XML digital signature :)
(: First generate a signed document, then validate it :)
import module namespace crypto = "http://expath.org/ns/crypto";

let $doc :=
  <message>
    <text>This document is signed.</text>
  </message>
let $signed := crypto:generate-signature(
  $doc, "exclusive", "SHA256", "RSA_SHA256", "dsig", "enveloped"
)
return
  <result>
    <valid>{crypto:validate-signature($signed)}</valid>
  </result>
