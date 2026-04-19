import module namespace md = "http://exist-db.org/xquery/markdown";

(: Render markdown to HTML with hard-wraps enabled :)
md:to-html(
    "Line one
Line two
Line three",
    map { "hard-wraps": true() }
)
