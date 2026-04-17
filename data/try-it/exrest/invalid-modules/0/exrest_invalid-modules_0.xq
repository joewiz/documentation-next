(: List XQuery modules that RESTXQ found to be invalid during resource function discovery :)
try {
  let $invalid := exrest:invalid-modules()
  return
    if (exists($invalid)) then
      <invalid-modules>
        {
          for $m in $invalid
          return <module>{$m}</module>
        }
      </invalid-modules>
    else
      <invalid-modules count="0">No invalid modules found.</invalid-modules>
} catch * {
  "exrest:invalid-modules#0 — " || $err:description
}
