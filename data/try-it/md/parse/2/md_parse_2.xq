import module namespace md = "http://exist-db.org/xquery/markdown";

(: Parse with the commonmark profile and explicit extensions :)
md:parse(
    "# CommonMark Profile

A paragraph with ~~strikethrough~~ and a [link](https://exist-db.org).

- [x] Task complete
- [ ] Task pending
",
    map {
        "profile": "commonmark",
        "extensions": ("tables", "strikethrough", "tasklist")
    }
)
