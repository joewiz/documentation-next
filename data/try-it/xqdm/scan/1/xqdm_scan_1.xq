(: Scan a stored XQuery module and extract XQDoc documentation :)
(: The module URI can point to a database path (xmldb:exist://...) or a file :)
try {
  let $result :=
    xqdm:scan(xs:anyURI("xmldb:exist:///db/apps/docs/modules/fundocs.xqm"))
  return
    if (exists($result)) then
      $result
    else
      "xqdm:scan returned empty — the XQDoc scanner may not support all XQuery syntax"
} catch * {
  "xqdm:scan#1 — " || $err:description
}
