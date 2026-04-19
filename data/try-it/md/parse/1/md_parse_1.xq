import module namespace md = "http://exist-db.org/xquery/markdown";

(: Parse a GitHub-flavored markdown string into md:* XML elements :)
md:parse("# Hello World

A paragraph with **bold** and *italic* text.

- Item one
- Item two

| Name | Value |
|------|-------|
| A    | 1     |
| B    | 2     |
")
