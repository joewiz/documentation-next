(: Full-text search with query options :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $opts := map {
    "leading-wildcard": "yes",
    "filter-rewrite": "yes"
}
for $hit in $data//p[ft:query(., "*quer*", $opts)]
order by ft:score($hit) descending
return
    <result score="{round(ft:score($hit), 4)}">
        {normalize-space($hit)}
    </result>
