(: fn:error#1 raises an error with a code :)
try { error(xs:QName("app:DEMO001")) }
catch * { "Caught: " || $err:code }