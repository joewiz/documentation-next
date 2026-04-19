---
query: |
  import module namespace vector = "http://exist-db.org/xquery/vector";
  vector:models()
---

Lists all available embedding model identifiers. Models come from the `<vector-models>` registry in `conf.xml` and built-in defaults (local ONNX models and HTTP API providers like OpenAI and Cohere).

## Examples

```xquery
(: List available models :)
import module namespace vector = "http://exist-db.org/xquery/vector";
vector:models()
```

Returns a sequence like:

```
"all-MiniLM-L6-v2"
"all-MiniLM-L12-v2"
"text-embedding-ada-002"
"text-embedding-3-small"
...
```

Use `vector:diagnostics()` for detailed information about each model's availability and configuration.
