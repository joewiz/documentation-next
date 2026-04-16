let $driver := "hello"
let $create-db := true()
return
    xmldb:register-database($driver, $create-db)