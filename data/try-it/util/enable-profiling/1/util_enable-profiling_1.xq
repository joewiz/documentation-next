(: enable-profiling controls query profiling :)
try { util:enable-profiling(10) }
catch * { "enable-profiling: " || $err:description }