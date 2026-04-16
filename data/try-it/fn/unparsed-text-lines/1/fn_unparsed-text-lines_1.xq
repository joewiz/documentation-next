let $source := "/db/apps/docs/data/try-it/fn/sort/3/fn_sort_3.xq"
return
    for $line at $n in unparsed-text-lines($source)
    return $n || ": " || $line