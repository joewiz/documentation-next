(: load-xquery-module dynamically loads a module :)
let $mod := load-xquery-module("http://www.w3.org/2005/xpath-functions/math")
return
    map:keys($mod?functions)