(: load-xquery-module with options :)
let $mod := load-xquery-module("http://www.w3.org/2005/xpath-functions/math", map {})
return
    map:keys($mod?functions)