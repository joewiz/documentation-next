# Try-It Module Coverage

Status of try-it query coverage across all eXist-db modules.

**Legend:** Done = all functions have try-it files and pass validation

## W3C Standard Libraries

- [x] **fn** (344 functions) — `http://www.w3.org/2005/xpath-functions`
- [x] **array** (38 functions) — `http://www.w3.org/2005/xpath-functions/array`
- [x] **map** (20 functions) — `http://www.w3.org/2005/xpath-functions/map`
- [x] **math** (18 functions) — `http://www.w3.org/2005/xpath-functions/math`

## EXPath Standard Libraries

- [x] **bin** (40 functions) — `http://expath.org/ns/binary`
- [x] **file** / exfile (58 functions) — `http://expath.org/ns/file` (uses `exfile:` prefix in queries to avoid conflict)
- [ ] **http** (3 functions) — `http://expath.org/ns/http-client`
- [ ] **crypto** (8 functions) — `http://expath.org/ns/crypto` — loaded from XAR, not conf.xml
- [ ] **zip** (6 functions) — `http://expath.org/ns/zip`

## Core eXist-db Modules — Priority

- [x] **util** (114 functions) — `http://exist-db.org/xquery/util` — scaffolds, needs validation pass
- [x] **xmldb** (50 functions) — `http://exist-db.org/xquery/xmldb` — scaffolds, needs validation pass
- [x] **system** (39 functions) — `http://exist-db.org/xquery/system` — scaffolds, needs validation pass
- [x] **sm** (59 functions) — `http://exist-db.org/xquery/securitymanager` — scaffolds, needs validation pass
- [x] **request** (31 functions) — `http://exist-db.org/xquery/request` — scaffolds, needs validation pass
- [x] **response** (10 functions) — `http://exist-db.org/xquery/response` — scaffolds, needs validation pass
- [ ] **file** (native) — `http://exist-db.org/xquery/file` — eXist's native file module (file:sync, file:serialize, etc.); registered in conf.xml as `file:`, no import needed
- [ ] **vector** — `http://exist-db.org/xquery/vector` — vector similarity search (new in next-v2, DJL/HuggingFace)
- [ ] **kwic** — KWIC module (see [KWIC article](http://localhost:8080/exist/apps/docs/articles/kwic)); XQuery library at `resource:org/exist/xquery/lib/kwic.xqm`
- [ ] **test** — XQSuite test framework (see [XQSuite article](http://localhost:8080/exist/apps/docs/articles/xqsuite))

## Indexing & Search Modules

- [x] **ft** (29 functions, 12 queries) — `http://exist-db.org/xquery/lucene`
- [x] **ngram** (6 functions, 7 queries) — `http://exist-db.org/xquery/ngram`
- [ ] **range** (24 functions) — `http://exist-db.org/xquery/range`
- [ ] **sort** (6 functions) — `http://exist-db.org/xquery/sort`

## Application & Infrastructure Modules

- [ ] **session** (15 functions) — `http://exist-db.org/xquery/session`
- [ ] **repo** (13 functions) — `http://exist-db.org/xquery/repo`
- [ ] **scheduler** (12 functions) — `http://exist-db.org/xquery/scheduler`
- [ ] **transform** (4 functions) — `http://exist-db.org/xquery/transform`
- [ ] **validation** (14 functions) — `http://exist-db.org/xquery/validation`
- [ ] **inspect** (6 functions) — `http://exist-db.org/xquery/inspection`
- [ ] **console** (3 functions) — `http://exist-db.org/xquery/console` — loaded from XAR
- [ ] **cache** (11 functions) — `http://exist-db.org/xquery/cache`

## Specialty Modules

- [ ] **compression** (24 functions) — `http://exist-db.org/xquery/compression`
- [ ] **contentextraction** (3 functions) — `http://exist-db.org/xquery/contentextraction`
- [ ] **counter** (4 functions) — `http://exist-db.org/xquery/counter`
- [ ] **image** (6 functions) — `http://exist-db.org/xquery/image`
- [ ] **mail** (13 functions) — `http://exist-db.org/xquery/mail`
- [ ] **sql** (13 functions) — `http://exist-db.org/xquery/sql`
- [ ] **xslfo** (2 functions) — `http://exist-db.org/xquery/xslfo`
- [ ] **xmldiff** (2 functions) — `http://exist-db.org/xquery/xmldiff`
- [ ] **xqdm** (2 functions) — `http://exist-db.org/xquery/xqdoc`
- [ ] **backups** (2 functions) — `http://exist-db.org/xquery/backups`
- [ ] **process** (1 function) — `http://exist-db.org/xquery/process`
- [ ] **md** (5 functions) — `http://exist-db.org/xquery/markdown` — loaded from XAR
- [ ] **cqlparser** (1 function) — `http://exist-db.org/xquery/cqlparser`
- [ ] **simpleql** (1 function) — `http://exist-db.org/xquery/simple-ql`

## RESTXQ & API Modules

- [ ] **rest** (3 functions) — `http://exquery.org/ns/restxq`
- [ ] **exrest** (8 functions) — `http://exquery.org/ns/restxq/exist`
- [ ] **req** (19 functions) — `http://exquery.org/ns/request`
- [ ] **lsp** (17 functions) — `http://exist-db.org/xquery/lsp` — loaded from XAR
- [ ] **api** (0 functions) — `http://exist-db.org/xquery/api` — loaded from XAR

## conf.xml-only Modules (not loaded in current runtime)

These are in `exist-distribution/src/main/config/conf.xml` but not currently registered:

- [ ] **exi** — `http://exist-db.org/xquery/exi` — EXI (Efficient XML Interchange) support
- [ ] **exiftool** — `http://exist-db.org/xquery/exiftool` — EXIF metadata extraction
- [ ] **oracle** — `http://exist-db.org/xquery/oracle` — Oracle DB integration
- [ ] **spatial** — `http://exist-db.org/xquery/spatial` — spatial/GIS index

## Other

- [ ] **jndi** (8 functions) — `http://exist-db.org/xquery/jndi`
- [ ] **ws** (5 functions) — `http://exist-db.org/xquery/websocket` — loaded from XAR
- [ ] **plogin** (3 functions) — `http://exist-db.org/xquery/persistentlogin`

---

## Summary

| Status | Count | Functions |
|--------|-------|-----------|
| Done (validated) | 14 modules | ~836 |
| Scaffolds (need validation) | 6 core modules | ~303 |
| Not started | ~29 modules | ~250+ |
| **Total** | ~49 modules | ~1186+ |

## Validation Status (as of 2026-04-16)

| Module | Files | Pass | Rate | Notes |
|--------|-------|------|------|-------|
| fn | 345 | 345/345 | 100% | All W3C standard functions |
| array | 38 | 38/38 | 100% | |
| map | 20 | 20/20 | 100% | |
| math | 18 | 18/18 | 100% | |
| bin | 40 | 40/40 | 100% | EXPath Binary; uses `import module` |
| file | 43 | 43/43 | 100% | EXPath File; uses `exfile:` prefix |
| ft | 12 | 12/12 | 100% | Hand-crafted with sample data |
| ngram | 7 | 7/7 | 100% | Hand-crafted with sample data |
| kwic | 4 | 2/4 | 50% | 2 need Lucene match context |
| test | 1 | 0/1 | 0% | Needs inspect context; works via REST |
| util | 114 | 107/114 | 94% | 7 edge cases |
| xmldb | 50 | 47/50 | 94% | 3 edge cases |
| system | 39 | 39/39 | 100% | Dangerous functions safely wrapped |
| sm | 59 | 59/59 | 100% | Read-only demos; mutating functions show signatures |
| request | 31 | 31/31 | 100% | try/catch for missing HTTP context |
| response | 10 | 10/10 | 100% | Signature descriptions for HTTP-only functions |
| **Total** | **831** | **818** | **98.4%** | |

## Known Issues

### Validation environment limitations

The validator uses `util:eval()` to execute each .xq file. Some functions cannot succeed in this context:

- **Lucene match context**: `kwic:summarize` and `kwic:display-text` require an active `ft:query()` match context that doesn't survive `util:eval()` boundaries. These work correctly when run in a single query (e.g., via eXide or the try-it widget).
- **Inspect context**: `test:suite` needs `inspect:module-functions()` on a stored module, which requires the module to be compiled in the current request context.
- **Persistent node IDs**: `util:node-by-id` requires a node from a persistent (stored) document, not an in-memory node.
- **Eval context nesting**: Some `util:eval-*` variants fail when nested inside another `util:eval()` call (the validator's own execution mechanism).
- **Index-by-QName**: `util:index-keys-by-qname` requires a specific index configuration that may not match the test data.

### Dangerous functions (safely wrapped)

These functions have side effects and are wrapped to prevent accidental execution:

- `system:shutdown`, `system:import`, `system:export`, `system:restore` — show descriptions only
- `system:kill-running-xquery`, `system:trigger-system-task` — show running query info instead
- `sm:create-account`, `sm:remove-account`, `sm:passwd`, `sm:chown`, `sm:chmod`, etc. — show signature descriptions

### HTTP-context-dependent functions

The `request:` and `response:` modules require an active HTTP request/response context. The try-it examples use try/catch to gracefully handle the missing context when run via `util:eval()`. These functions work correctly when invoked from controller.xq, RESTXQ, or other HTTP-triggered XQuery.

### Server stability during bulk validation

Running hundreds of `util:eval()` calls in rapid succession can exhaust memory and crash the server. The throttled validator (`tools/validate-tryit-throttled.sh`) checks broker availability and free memory between batches to mitigate this. Consider using `util:compile()` or LSP endpoints for static-only validation.

### Workflow note

Always do try-it work on disk first, then deploy via XAR. Never rely on DB-only state — server crashes can corrupt the database, and XAR redeployment restores from filesystem.

## Notes

- The native `file` module (`http://exist-db.org/xquery/file`) provides `file:sync`, `file:serialize`, `file:serialize-binary` — different from the EXPath `file` module. Registered in conf.xml as `file:`, no import needed. However, when the EXPath file module is installed, it shadows the native module's `file:` prefix at runtime.
- `kwic` is not a registered Java module — it's an XQuery library at `resource:org/exist/xquery/lib/kwic.xqm`
- `test` is the XQSuite annotation-based test framework at `resource:org/exist/xquery/lib/xqsuite/xqsuite.xql`
- Modules marked "loaded from XAR" are installed via packages, not conf.xml
- Some modules (mail, sql, jndi, oracle) require external services
- `request`, `response`, `session` are HTTP-context-dependent
- `exi`, `exiftool`, `oracle`, `spatial` may not have their required dependencies available in all deployments
- `vector` is new in next-v2 for vector similarity search (DJL/HuggingFace, PR #6146)
- Good sources for improving examples: eXist XQSuite tests (`~/workspace/exist`), qt4tests (`~/workspace/qt4tests`), W3C spec (`https://qt4cg.org/specifications/xpath-functions-40/Overview.html`)
- The exist-xqts-runner (`~/workspace/exist-xqts-runner`) provides a model for running large test suites without clobbering the server
