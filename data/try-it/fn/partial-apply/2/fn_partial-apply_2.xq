let $function := concat#3
let $arguments := map { 1: "Hello " }
return
    partial-apply($function, $arguments)("World", "!")