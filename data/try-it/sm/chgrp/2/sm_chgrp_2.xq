let $path := "/db/apps/docs"
let $group-name := "hello"
return
    sm:chgrp($path, $group-name)