let $dir-or-file := "hello"
let $admin-pass := "hello"
let $new-admin-pass := "hello"
return
    system:import-silently($dir-or-file, $admin-pass, $new-admin-pass)