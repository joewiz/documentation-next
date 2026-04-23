---
query: |
  import module namespace vector = "http://exist-db.org/xquery/vector";

  let $vec := vector:embed("semantic search with XQuery", "all-MiniLM-L6-v2")
  return
      <embedding dimension="{array:size($vec)}">
          {string-join(
              for-each(array:subarray($vec, 1, 5)?*, function($v) {
                  string(round($v * 10000) div 10000)
              }), ", "
          )}...
      </embedding>
---

Generates a vector embedding for the given text using the specified model. Returns an `array(*)` of float values suitable for use with [`ft:query-vector()`]({docs}/functions/ft/query-vector) and [`ft:query-field-vector()`]({docs}/functions/ft/query-field-vector).

The 2-arity form resolves the model via the `<vector-models>` registry in `conf.xml` or built-in defaults. The 3-arity form accepts an explicit model path. The 4-arity form also accepts an API key for HTTP-based providers.

## Semantic Search Example

```xquery
import module namespace vector = "http://exist-db.org/xquery/vector";

(: Generate embedding for user's query :)
let $query-vec := vector:embed("machine learning algorithms", "all-MiniLM-L6-v2")

(: KNN search against vector-indexed collection :)
for $hit in collection("/db/articles")//article[ft:query-field-vector("content-vec", $query-vec, 5)]
let $score := ft:score($hit)
order by $score descending
return
    <result score="{round($score * 1000) div 1000}">{$hit/title/string()}</result>
```

## Comparing Embeddings

```xquery
import module namespace vector = "http://exist-db.org/xquery/vector";

(: Embed two phrases and compare their vectors :)
let $v1 := vector:embed("artificial intelligence", "all-MiniLM-L6-v2")
let $v2 := vector:embed("machine learning", "all-MiniLM-L6-v2")

(: Cosine similarity — dot product of normalized vectors :)
let $dot := sum(for-each(1 to array:size($v1), function($i) { $v1($i) * $v2($i) }))
return
    <similarity>{round($dot * 1000) div 1000}</similarity>
```
