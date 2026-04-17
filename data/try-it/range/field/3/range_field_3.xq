(: General field lookup with explicit operator strings :)
(: range:field allows specifying field names, operators, and keys as sequences :)
(: Operators: "eq", "ne", "lt", "gt", "le", "ge", "starts-with", "ends-with", "contains", "matches" :)
try {
  let $data := collection("/db/apps/docs/data/try-it/range/data")
  for $city in $data//range:field("city-country", "eq", "France")
  return
    $city/name || " (" || $city/country || ")"
} catch * {
  "range:field#3 — " || $err:description
}
