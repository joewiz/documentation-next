let $username := "hello"
let $password-digest := "hello"
return
    sm:passwd-hash($username, $password-digest)