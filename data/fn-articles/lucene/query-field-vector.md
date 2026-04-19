---
query: |
  import module namespace vector = "http://exist-db.org/xquery/vector";

  (: Semantic search: find documents about "artificial intelligence" :)
  let $query-vec := vector:embed("artificial intelligence", "all-MiniLM-L6-v2")
  for $hit in collection("/db/vector-test")//article
      [ft:query-field-vector("content-vec", $query-vec, 3)]
  let $score := ft:score($hit)
  order by $score descending
  return
      <result score="{round($score * 1000) div 1000}">
          {$hit/title}
      </result>
---

Performs a K-nearest-neighbor (KNN) vector similarity search on a named vector field. Returns the `k` most similar documents based on the configured similarity metric (cosine, euclidean, or dot product).

The vector field must be configured in the collection's `collection.xconf` as a `<vector-field>` inside a `<text>` index. The query vector must have the same dimension as the indexed vectors.

## Prerequisites

The collection must have a vector field index configured:

```xml
<collection xmlns="http://exist-db.org/collection-config/1.0">
    <index xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <lucene>
            <text qname="article">
                <vector-field name="content-vec" expression="."
                    dimension="384" similarity="cosine"
                    embedding="local" model="all-MiniLM-L6-v2"/>
            </text>
        </lucene>
    </index>
</collection>
```

## Combined Full-Text and Vector Search

```xquery
import module namespace vector = "http://exist-db.org/xquery/vector";

(: Combine keyword filtering with semantic ranking :)
let $query-vec := vector:embed("database performance", "all-MiniLM-L6-v2")
for $hit in collection("/db/articles")//article
    [ft:query(., "database")]
    [ft:query-field-vector("content-vec", $query-vec, 10)]
let $score := ft:score($hit)
order by $score descending
return
    <result score="{round($score * 1000) div 1000}">{$hit/title}</result>
```
