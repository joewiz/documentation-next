(: fn:error#3 raises an error with code, description, and value :)
try { error(xs:QName("app:DEMO001"), "Bad value", 42) }
catch * { "Code: " || $err:code || ", Message: " || $err:description || ", Value: " || $err:value }