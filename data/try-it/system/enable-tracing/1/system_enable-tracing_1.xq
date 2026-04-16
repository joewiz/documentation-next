(: Enable query tracing :)
let $was := system:tracing-enabled()
let $_ := system:enable-tracing(true())
let $now := system:tracing-enabled()
let $_ := system:enable-tracing($was)
return "Tracing was " || $was || ", temporarily set to " || $now
