import module namespace exfile = "http://expath.org/ns/file";

(: Get the filename from a path :)
(
    exfile:name("/home/user/document.xml"),
    exfile:name("/home/user/"),
    exfile:name("file.txt")
)
