import module namespace md = "http://exist-db.org/xquery/markdown";

(: Render markdown directly to HTML :)
md:to-html("## Quick Example

Markdown with a `code span` and a [link](https://exist-db.org).

```xquery
for $i in 1 to 3
return $i * $i
```
")
