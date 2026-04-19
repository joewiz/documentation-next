---
query: |
  import module namespace vector = "http://exist-db.org/xquery/vector";
  vector:diagnostics()
---

Returns XML elements with diagnostic information for all registered and built-in embedding models, including path, dimension, source (builtin or registry), and availability status.

## Examples

```xquery
import module namespace vector = "http://exist-db.org/xquery/vector";
vector:diagnostics()
```

Returns elements like:

```xml
<vector:model id="all-MiniLM-L6-v2" source="builtin"
    path="onnx-models/all-MiniLM-L6-v2" dimension="384" status="available"/>
<vector:model id="text-embedding-3-small" source="builtin"
    path="https://api.openai.com/v1" dimension="1536" status="unavailable"/>
```

Use the `status` attribute to check which models are ready for use. A local ONNX model shows `status="available"` when its model directory exists under `$EXIST_HOME`. HTTP models show `status="unavailable"` unless the corresponding API key environment variable is set.
