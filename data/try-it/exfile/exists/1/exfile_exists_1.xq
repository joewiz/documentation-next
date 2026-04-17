import module namespace exfile = "http://expath.org/ns/file";

(: Check if a file or directory exists :)
(
    exfile:temp-dir() || " exists: " || exfile:exists(exfile:temp-dir()),
    "/nonexistent exists: " || exfile:exists("/nonexistent")
)
