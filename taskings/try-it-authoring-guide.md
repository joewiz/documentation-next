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
- **Function count** — get the full list:

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
   - **Try/catch wrapper**: `try { dangerous-fn() } catch * { "Error: " || $err:description }`
   - **Description only**: `"fn:name#arity — requires specific context/permissions"`

5. **For context-dependent functions** (request, response, session):
   - Wrap in try/catch: `try { request:get-method() } catch * { "requires HTTP context" }`

6. **For functions needing imports** (not auto-registered):
   - Add import in the prolog: `import module namespace exfile = "http://expath.org/ns/file";`
   - The native eXist `file:` module is registered in conf.xml — no import needed
   - The EXPath `file` module uses prefix `exfile:` to avoid conflict

7. **Use comments** to explain what the query demonstrates:
   ```xquery
   (: Pack an integer into binary with big-endian byte order :)
   xs:hexBinary(bin:pack-integer(256, 2, "most-significant-first"))
   ```

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
| collation URI | `"http://www.w3.org/2013/collation/UCA"` |
| collection path | `"/db/apps/docs/data/try-it/ft/data"` |
