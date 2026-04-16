let $dir := "hello"
let $incremental := true()
let $zip := true()
return
    system:export($dir, $incremental, $zip)