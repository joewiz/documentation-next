let $dir-or-file := "hello"
let $admin-pass := "hello"
let $new-admin-pass := "hello"
let $overwrite := true()
return
    system:restore($dir-or-file, $admin-pass, $new-admin-pass, $overwrite)