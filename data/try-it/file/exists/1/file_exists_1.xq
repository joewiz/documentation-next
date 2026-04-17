(: Check if a path exists on the filesystem :)
(
    "temp dir exists: " || file:exists(util:system-property("java.io.tmpdir")),
    "/nonexistent exists: " || file:exists("/nonexistent")
)
