(: Search and rank results by relevance score :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $hit in $data//line[ft:query(., "light OR night OR dark")]
let $score := ft:score($hit)
order by $score descending
return
    round($score, 4) || " — " || normalize-space($hit)
