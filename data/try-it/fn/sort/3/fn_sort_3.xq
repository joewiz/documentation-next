let $people := (
    map { "name": "Charlie", "age": 30 },
    map { "name": "Alice",   "age": 25 },
    map { "name": "Bob",     "age": 35 }
)
return
    for $p in sort($people, (), function($m) { $m?age })
    return $p?name || " (age " || $p?age || ")"
