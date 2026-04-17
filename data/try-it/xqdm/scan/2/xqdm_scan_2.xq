(: Scan XQDoc from inline XQuery source provided as base64 binary :)
try {
  let $source :=
    util:string-to-binary(
      'xquery version "1.0";
module namespace m = "http://example.com/math";

(:~ Adds two numbers.
 : @param $a first number
 : @param $b second number
 : @return the sum
 :)
declare function m:add($a as xs:integer, $b as xs:integer) as xs:integer {
  $a + $b
};'
    )
  let $result := xqdm:scan($source, "math-module.xq")
  return
    if (exists($result)) then
      $result
    else
      "xqdm:scan returned empty — the XQDoc scanner may not support all XQuery syntax"
} catch * {
  "xqdm:scan#2 — " || $err:description
}
