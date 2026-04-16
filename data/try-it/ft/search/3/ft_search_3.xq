(: Wildcard search with KWIC highlighting :)
import module namespace kwic = "http://exist-db.org/xquery/kwic";

let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $hit in $data//line[ft:query(., "rage*")]
let $kwic := kwic:summarize($hit, <config width="40"/>)
return
    <result score="{ft:score($hit)}">
        {$kwic}
    </result>
