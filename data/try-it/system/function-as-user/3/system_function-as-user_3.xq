let $username := "hello"
let $password := "hello"
let $function := function($x) { $x }
return
    system:function-as-user($username, $password, $function)