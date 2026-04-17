# Tasking: Write Try-It Queries for a Module

## Objective

Create runnable XQuery examples for every function in a given eXist-db module. Each example should be a standalone `.xq` file that executes without errors and demonstrates the function's purpose.

## Prerequisites

- Docker container `existdb-next-v2` running on `localhost:8080`
- The docs app deployed: `cd ~/workspace/documentation-next && npm run build && xst package install --force dist/*.xar`
- The eXide app available at `~/workspace/eXide` (for prettier formatting)
- Access to function signatures: `http://localhost:8080/exist/apps/docs/functions/{prefix}`

## Step 1: Identify the Module

Check `taskings/try-it-module-coverage.md` for modules that still need coverage. Pick one and note its:
- **Prefix** (e.g., `transform`)
- **Namespace URI** (e.g., `http://exist-db.org/xquery/transform`)
- **Function count**

### Verify the module is loadable

Before writing any queries, confirm the module is available in the running instance:

```bash
xst run 'inspect:inspect-module-uri(xs:anyURI("http://exist-db.org/xquery/transform"))'
```

This returns an XML description with all function signatures and arities. If it fails with `XQST0059 failed to load module`, the module is not registered in the current runtime — skip it and note why in the coverage tracker.

Some modules listed in the coverage tracker are conf.xml-only (commented out or requiring external dependencies like `exiftool`, `exi`, `spatial`) or require a XAR that isn't installed (like `vector`). These cannot be covered until activated.

You can also batch-check multiple modules at once:

```bash
for uri in "http://exist-db.org/xquery/zip" "http://exist-db.org/xquery/exi"; do
  echo "=== $uri ==="
  xst run "try { count(inspect:inspect-module-uri(xs:anyURI('$uri'))//function) } catch * { 'NOT LOADED' }" 2>&1
done
```

Modules confirmed as not loaded in the current runtime: `zip`, `exi`, `oracle`, `spatial`, and the native `file` module (`http://exist-db.org/xquery/file` — shadowed by the EXPath file module's XAR).

### Alternative: get the function list from the docs app

If the module is already registered in the docs app, you can also query it via:

```xquery
import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "/db/apps/docs/modules/fundocs.xqm";
let $mod := fundocs:get-module("{prefix}")[1]
for $fn in $mod?functions?*
return $fn?local-name || "#" || $fn?arity || " — " || $fn?signature
```

## Step 2: Create the Directory Structure

For each function `{prefix}:{name}#{arity}`, create:

```
data/try-it/{prefix}/{name}/{arity}/{prefix}_{name}_{arity}.xq
```

Example for `transform:transform#3`:
```
data/try-it/transform/transform/3/transform_transform_3.xq
```

Create directories in bulk:
```bash
mkdir -p data/try-it/{prefix}/{name}/{arity}
```

## Step 3: Write the Queries

### Guidelines

1. **Every query must be runnable** — it should execute without errors when pasted into the try-it widget or eXide.

2. **Use real data** when possible:
   - Sample data in `data/try-it/{prefix}/data/` (create collection.xconf if indexes are needed)
   - Existing data at `/db/apps/docs/data/try-it/ft/data/` (poems, glossary)
   - The docs app's own data at `/db/apps/docs/data/`

3. **For multiple arities, highlight the differences**:
   ```xquery
   (: sort#1 — default sorting :)
   sort(("banana", "apple", "cherry"))
   ```
   ```xquery
   (: sort#2 — with collation :)
   sort(("Über", "alpha"), "http://www.w3.org/2013/collation/UCA?lang=en")
   ```
   ```xquery
   (: sort#3 — with collation and key function :)
   sort(($people), (), function($m) { $m?age })
   ```

4. **For dangerous/mutating functions**, use one of these patterns:
   - **Create-then-cleanup**: `let $_ := xmldb:store(...) ... let $_ := xmldb:remove(...)`
   - **Create-then-destroy** (for stateful modules like cache, counter, sort): `let $_ := cache:create("demo", ...) ... let $_ := cache:destroy("demo")` — ensures no state leaks between runs
   - **Try/catch wrapper**: `try { dangerous-fn() } catch * { "Error: " || $err:description }`
   - **Description only**: `"fn:name#arity — requires specific context/permissions"`

5. **For context-dependent functions** (request, response, session, req, rest):
   - Wrap in try/catch: `try { request:get-method() } catch * { "requires HTTP context" }`
   - These functions work correctly in the try-it widget (which has HTTP context) but fail via `util:eval()` in the validator

6. **For external-service modules** (mail, sql, jndi) where no server is available:
   - Use **description-only strings** for every function
   - Include the full signature and a brief explanation of the XML format for parameters:
     ```xquery
     (: Open a JDBC connection :)
     "sql:get-connection($driver as xs:string, $url as xs:string) as xs:long? — opens a connection using the JDBC driver and URL"
     ```
   - This pattern also applies to `plogin` (requires session tokens) and mutating `scheduler`/`repo`/`exrest` functions

7. **For functions needing imports** (not auto-registered):
   - Add import in the prolog: `import module namespace exfile = "http://expath.org/ns/file";`
   - The EXPath `file` module uses prefix `exfile:` to avoid conflict with the native `file:` prefix
   - **XAR-loaded modules** need explicit imports without an `at` clause:
     ```xquery
     import module namespace crypto = "http://expath.org/ns/crypto";
     import module namespace http = "http://expath.org/ns/http-client";
     import module namespace console = "http://exist-db.org/xquery/console";
     import module namespace md = "http://exist-db.org/xquery/markdown";
     ```
   - **conf.xml-registered modules** (transform, validation, compression, cache, counter, image, xmldiff, xslfo, cqlparser, simpleql, scheduler, backups, mail, sql, jndi, etc.) need no import at all — they are available by default

8. **Use comments** to explain what the query demonstrates:
   ```xquery
   (: Pack an integer into binary with big-endian byte order :)
   xs:hexBinary(bin:pack-integer(256, 2, "most-significant-first"))
   ```

9. **Watch for exact type requirements** in Java module functions:
   - Java modules may require exact types (e.g., `xs:long` vs `xs:integer`). If you get a static type error, check the function signature and add an explicit cast: `counter:create("name", xs:long(100))`.

10. **Java module bugs** — some functions crash with Java-level errors that XQuery try/catch cannot always intercept:
   - Workarounds: change the input data (e.g., add `targetNamespace` to an XSD to avoid a null pointer in `validation:pre-parse-grammar`), wrap in try/catch (may or may not catch it depending on where the NPE occurs), or fall back to a description-only string.
   - Known examples: `contentextraction:get-metadata` Tika RuntimeException, `compression:tar` header-size bug, `compression:unzip#3` requiring a 3-arg filter despite the signature showing 2.

### Reference sources for examples

- **W3C/QT4CG spec**: https://qt4cg.org/specifications/xpath-functions-40/Overview.html
- **qt4tests**: `~/workspace/qt4tests/fn/`, `~/workspace/qt4tests/bin/`, `~/workspace/qt4tests/file/`
- **eXist XQSuite tests**: `~/workspace/exist/exist-core/src/test/` and `~/workspace/exist/extensions/`
- **eXist-db documentation**: `http://localhost:8080/exist/apps/docs/articles/`

### Sample data collections

If the module needs indexed data (like `ft:` or `ngram:`), create:
```
data/try-it/{prefix}/data/collection.xconf   — index configuration
data/try-it/{prefix}/data/sample.xml         — sample documents
```

The `finish.xq` post-install script will automatically deploy the collection.xconf to `/db/system/config/` and reindex.

Binary sample data (images, XSD schemas, etc.) can also be stored in `data/try-it/{prefix}/data/`. Reference them in queries with:
```xquery
util:binary-doc("/db/apps/docs/data/try-it/{prefix}/data/filename.png")
doc("/db/apps/docs/data/try-it/{prefix}/data/schema.xsd")
```

Examples:
- `ft` module uses poems and glossary XML with Lucene indexes
- `range` module uses city data with both simple element and complex field indexes
- `image` module uses a sample PNG
- `validation` module uses a sample XSD with a `targetNamespace`
- `sort` module reuses the range module's stored city data (no sample data of its own)

## Step 4: Format with Prettier

```bash
cd ~/workspace/eXide
find ~/workspace/documentation-next/data/try-it/{prefix} -name "*.xq" \
    -exec npx prettier --plugin prettier-plugin-xquery --write {} +
```

## Step 5: Update the Registry

If this is a new module not yet in `data/try-it/registry.xml`, add an entry:
```xml
<module dir="{prefix}" uri="{namespace-uri}" prefix="{prefix}"/>
```

## Step 6: Deploy and Validate

### Deploy
```bash
cd ~/workspace/documentation-next
npm run build && xst package install --force dist/*.xar
```

### Validate with the throttled validator
```bash
bash tools/validate-tryit-throttled.sh {prefix}
```

This checks broker availability and memory between batches to avoid server crashes. Expected output:
```
=== Throttled Try-it Validation ===
--- {prefix} ---
  {prefix}: N queries checked
=== Summary ===
Total: N | OK: N | Errors: 0
```

### If there are errors

1. Read the error messages — common causes:
   - **"Collection X not found"** — use a real DB path like `/db/apps/docs/data/...`
   - **"Type error: Function does not have expected arity"** — `function($x) { $x }` needs 2 args for fold/for-each-pair
   - **"Unknown collation"** — use `"http://www.w3.org/2013/collation/UCA"`
   - **"Context item is absent"** — use XPath context: `<el/>/local-name()` or `(1 to 10)[last()]`
   - **XPST0003 static error** — check for corrupted file content; re-check XQuery syntax
   - **Static type error with numeric literals** — Java modules expecting `xs:long` reject plain integer literals; use `xs:long(N)`
   - **"entry-filter function must take at least 3 arguments"** — `compression:unzip#3` requires a 3-arg filter at runtime despite the signature showing 2; use `unzip#6` with inline functions as a workaround
   - **"Cannot invoke ... because this.value is null"** — Java NPE in the module; try changing the input data (e.g., add `targetNamespace` to XSD)
   - **"Request to write N bytes exceeds size in header of 0 bytes"** — `compression:tar` header-size bug; wrap in try/catch
   - **"unexpected docvalues type NONE for field"** — range index numeric field comparisons (`range:field-gt/lt/le/ge` on `xs:integer` fields) fail; use string-typed fields for field-level comparisons instead
   - **"Cannot run program ... No such file or directory"** — `process:execute` can't find executables in Docker; wrap in try/catch
   - **"headers" is null** — `http:send-request#3` NPE when sending a body; wrap in try/catch
   - **Empty result from xqdm:scan** — the XQDoc scanner silently returns empty for modern XQuery 3.1 syntax; wrap with fallback message

2. Fix the queries **on disk** (never rely on DB-only edits — they're lost on redeploy)

3. Re-deploy and re-validate

## Step 7: Report Results

Update `taskings/try-it-module-coverage.md`:

1. Check the box for the module in the appropriate section
2. Update the validation table with pass/fail counts
3. Add any new known issues to the Known Issues section

### Report format

```
## {prefix} module — try-it coverage complete

- Files: {count}
- Validated: {pass}/{total} ({percent}%)
- Errors: {list any remaining with brief explanation}
- Sample data: {yes/no — describe if created}
- Notes: {any module-specific quirks}
```

## Quick Reference: Type-Appropriate Default Values

| Type | Default Value |
|------|---------------|
| `xs:string` | `"hello"` |
| `xs:integer` | `42` |
| `xs:long` | `xs:long(42)` |
| `xs:boolean` | `true()` |
| `xs:date` | `xs:date("2025-06-15")` |
| `xs:dateTime` | `current-dateTime()` |
| `xs:anyURI` | `"/db/apps/docs"` |
| `xs:QName` | `xs:QName("fn:concat")` |
| `node()` | `<item>value</item>` |
| `item()*` | `(1, "two", <three/>)` |
| `map(*)` | `map { "a": 1, "b": 2 }` |
| `array(*)` | `["x", "y", "z"]` |
| `function(*)` | `function($x) { $x }` |
| `xs:base64Binary` | `util:string-to-binary("hello")` |
| `xs:duration` | `xs:dayTimeDuration("P1DT2H")` |
| `xs:int` | `1800` |
| collation URI | `"http://www.w3.org/2013/collation/UCA"` |
| collection path | `"/db/apps/docs/data/try-it/ft/data"` |
| AES key (16 bytes) | `"0123456789abcdef"` |
| DES key (8 bytes) | `"01234567"` |
| cron expression | `"0 0 * * * ?"` (every hour) |
| JDBC driver class | `"org.h2.Driver"` |
| SMTP host property | `<properties><property name="mail.smtp.host" value="smtp.example.com"/></properties>` |
