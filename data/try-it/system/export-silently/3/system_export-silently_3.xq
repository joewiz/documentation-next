let $dir := "hello"
let $incremental := true()
let $zip := true()
return
    system:export-silently($dir, $incremental, $zip)