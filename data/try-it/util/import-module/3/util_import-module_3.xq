let $module-uri := "/db/apps/docs"
let $prefix := "hello"
let $location := "/db/apps/docs"
return
    util:import-module($module-uri, $prefix, $location)