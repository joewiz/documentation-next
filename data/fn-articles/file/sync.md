---
query: |
  (: Sync the docs app data to a local directory :)
  file:sync("/db/apps/docs/data/articles", "/tmp/docs-articles-sync", map {
    "prune": false(),
    "indent": true()
  })
---

`file:sync#3` writes the contents of a database collection to a directory on the file system,
including the entire tree (subcollections and their contents).

Since eXist-DB 5.4.0 the third parameter can be either an `xs:dateTime` (kept for backwards compatibility)
or a map of options.

## Options Map

Serialization options (only applies to XML files at the moment) let you override some defaults:

- `indent`: `xs:boolean` — default `true()`. Whether to remove line-endings and extra whitespace from XML files (except in mixed content nodes).
- `omit-xml-declaration`: `xs:boolean` — default `true()`. Set to `false()` to include the XML declaration.
- `exist:expand-x-includes`: `xs:boolean` — default `false()`. Set to `true()` to expand XIncludes.
- `exist:insert-final-newline`: `xs:boolean` — default `false()`. Appends a newline to the end of each file, useful for git repositories.

Synchronization control options:

- `after`: `xs:dateTime?` — default `()`. Synchronize only files newer than the given dateTime.
- `prune`: `xs:boolean` — default `()`. If `true()`, removes files from the filesystem that are not in the database collection.
- `exclude`: `xs:string*` — glob patterns for files that should **not** be removed from disk (e.g. `".*"` to preserve dotfiles).

The function returns a `document-node()` reporting what was synchronized.

## Sync to a git repository

```xquery
file:sync("/db/apps/my-app", "/Users/me/projects/my-app", map {
  "prune": true(),
  "exclude": (".*")
})
```

## Synchronize changes from the last day

```xquery
file:sync("/db/apps/my-app", "/Users/me/projects/my-app", map {
  "after": current-dateTime() - xs:dayTimeDuration("PT1D")
})
```
