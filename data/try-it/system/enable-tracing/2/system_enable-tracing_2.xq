(: Enable tracing with a specific base :)
try { system:enable-tracing(true(), "org.exist.xquery") }
catch * { "enable-tracing#2: " || $err:description }
