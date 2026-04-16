let $dir-or-file := "hello"
let $admin-pass := "hello"
let $new-admin-pass := "hello"
return
    system:restore($dir-or-file, $admin-pass, $new-admin-pass)