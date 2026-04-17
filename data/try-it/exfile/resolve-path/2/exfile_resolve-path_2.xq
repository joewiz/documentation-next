import module namespace exfile = "http://expath.org/ns/file";

(: Resolve a path against a base directory :)
exfile:resolve-path("docs/readme.txt", "/home/user")
