---
query: |
  import module namespace vector = "http://exist-db.org/xquery/vector";

  let $texts := ("XML databases", "neural networks", "medieval history")
  let $embeddings := vector:embed-batch($texts, "all-MiniLM-L6-v2")
  return
      <batch count="{array:size($embeddings)}">{
          for $text at $i in $texts
          return
              <embedding text="{$text}" dimension="{array:size($embeddings($i))}"/>
      }</batch>
---

Embeds multiple texts in a single call, returning an `array(*)` of arrays (one embedding per input text). More efficient than calling `vector:embed()` in a loop — the model processes all inputs in one batch.

## Batch Indexing Example

```xquery
import module namespace vector = "http://exist-db.org/xquery/vector";

(: Batch-embed all document titles for pre-computed vector storage :)
let $docs := collection("/db/articles")//article
let $titles := $docs/title/string()
let $embeddings := vector:embed-batch($titles, "all-MiniLM-L6-v2")

return
    <indexed count="{array:size($embeddings)}">{
        for $doc at $i in $docs
        return
            <doc title="{$doc/title}" dimension="{array:size($embeddings($i))}"/>
    }</indexed>
```
