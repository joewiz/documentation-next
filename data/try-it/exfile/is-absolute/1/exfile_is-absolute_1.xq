import module namespace exfile = "http://expath.org/ns/file";

(: Check if a path is absolute :)
(
    "is-absolute(/tmp): " || exfile:is-absolute("/tmp"),
    "is-absolute(relative): " || exfile:is-absolute("relative/path")
)
