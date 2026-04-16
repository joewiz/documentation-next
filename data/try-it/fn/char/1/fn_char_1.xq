(: fn:char returns a character by its Unicode name :)
try { char("tab") }
catch * { "fn:char not yet supported for this name: " || $err:description }