import module namespace exfile = "http://expath.org/ns/file";

(: Convert a URI path to native OS path :)
exfile:path-to-native(exfile:temp-dir())
