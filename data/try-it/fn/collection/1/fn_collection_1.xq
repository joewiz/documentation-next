(: List all article titles in the docs collection :)
for $topic in collection("/db/apps/docs/data/articles")/topic
order by $topic/title
return $topic/title/string()
