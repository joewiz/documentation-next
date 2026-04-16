(: fn:error always raises an error — wrapped in try/catch for demo :)
try { error() }
catch * { "Caught: " || $err:code || " — " || $err:description }