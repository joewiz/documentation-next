let $source := "/db/apps/docs/data/try-it/fn/sort/3/fn_sort_3.xq"
let $encoding := "UTF-8"
return
    for $line at $n in unparsed-text-lines($source, $encoding)
    return $n || ": " || $line