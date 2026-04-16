(: fn:error#2 raises an error with code and description :)
try { error(xs:QName("app:DEMO001"), "Something went wrong") }
catch * { "Caught: " || $err:code || " — " || $err:description }