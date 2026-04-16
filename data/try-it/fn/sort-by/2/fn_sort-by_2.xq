(: sort-by sorts by extracted keys :)
let $people := (
    map { "name": "Charlie", "age": 30 },
    map { "name": "Alice", "age": 25 },
    map { "name": "Bob", "age": 35 }
)
return
    sort-by($people, map { "key": function($m) { $m?age } })