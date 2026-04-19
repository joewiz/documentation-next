(: Create a zip with a prefix stripped from entry names :)
let $entries := (
    <entry name="project/src/main.xq" type="text">1 + 1</entry>,
    <entry name="project/src/lib.xqm" type="text">module namespace lib = "lib";</entry>
)
return compression:zip($entries, false(), "project/")
