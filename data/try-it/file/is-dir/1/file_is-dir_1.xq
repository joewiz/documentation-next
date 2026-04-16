import module namespace exfile = "http://expath.org/ns/file";

(: Check if a path is a directory :)
(
    exfile:temp-dir() || " is-dir: " || exfile:is-dir(exfile:temp-dir())
)
