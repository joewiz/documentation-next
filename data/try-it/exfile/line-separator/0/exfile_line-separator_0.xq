import module namespace exfile = "http://expath.org/ns/file";

(: Get the platform line separator :)
"Line separator codepoints: " ||
    string-join(string-to-codepoints(exfile:line-separator()) ! string(.), ", ")
