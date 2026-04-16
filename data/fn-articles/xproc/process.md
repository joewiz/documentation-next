---
query: |
  import module namespace xproc="http://exist-db.org/xproc";
  
  let $pipeline := document {
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0">
      <p:input port="source">
        <p:inline><doc>Hello from XProc!</doc></p:inline>
      </p:input>
      <p:output port="result"/>
      <p:identity/>
    </p:declare-step>
  }
  return xproc:process($pipeline)
---

XProc is a standard language for defining XML document processing pipelines. The eXist-db `xproc` module
implements XProc using Calabash.

## Basic Usage

The XProc pipeline can be passed as a `document-node()`, an `element()`, or by URI:

```xquery
import module namespace xproc="http://exist-db.org/xproc";

let $pipeline := document {
  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0">
    <p:input port="source">
      <p:inline><doc>Hello world!</doc></p:inline>
    </p:input>
    <p:output port="result"/>
    <p:identity/>
  </p:declare-step>
}
return xproc:process($pipeline)
```

## Passing Options and Input Ports

Use `xproc:process($pipeline, $options)` to pass processing options:

```xquery
xproc:process($xproc, (
  <option name="someoption" value="somevalue"/>,
  <input type="xml" port="extrainputport" url="input.xml"/>
))
```

## Connecting Input Ports

```xml
<input type="xml" port="source" url="xmldb:exist:///db/path/to/document.xml"/>
```

- `type="xml"` — the URL must point to a well-formed XML document
- `type="data"` — the content is base64-encoded in a `<c:data>` wrapper

## Connecting Output Ports

```xml
<output port="extraresult" url="xmldb:///db/path/to/output.xml"/>
```

**Note:** Output URLs must use the `xmldb://` prefix (not `xmldb:exist://`).

## Known Limitations

- XQuery scripts called by the XProc pipeline run on Saxon inside Calabash, not on eXist's XQuery engine. Database access and eXist extension functions are not available inside these scripts.
- `<pxp:zip>` does not work properly (but `<pxp:unzip>` does).
