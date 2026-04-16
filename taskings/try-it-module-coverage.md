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
- [ ] **file** (native) — `http://exist-db.org/xquery/file` — eXist's native file module (file:sync, file:serialize, etc.); in conf.xml but not auto-loaded when EXPath file module is present; needs `import module` with `java:org.exist.xquery.modules.file.FileModule`
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
- [ ] **vector** — `http://exist-db.org/xquery/vector` — vector similarity search (new in next-v2)

## Other

- [ ] **jndi** (8 functions) — `http://exist-db.org/xquery/jndi`
- [ ] **ws** (5 functions) — `http://exist-db.org/xquery/websocket` — loaded from XAR
- [ ] **plogin** (3 functions) — `http://exist-db.org/xquery/persistentlogin`

---

## Summary

| Status | Count | Functions |
|--------|-------|-----------|
| Done (validated) | 8 modules | ~583 |
| Scaffolds (need validation) | 6 modules | ~303 |
| Not started | ~35 modules | ~300+ |
| **Total** | ~49 modules | ~1186+ |

## Notes

- The native `file` module (`http://exist-db.org/xquery/file`) provides `file:sync`, `file:serialize`, `file:serialize-binary` — different from the EXPath `file` module. It's in conf.xml but shadowed by the EXPath module at runtime. Needs explicit Java class import.
- `kwic` is not a registered Java module — it's an XQuery library at `resource:org/exist/xquery/lib/kwic.xqm`
- `test` is the XQSuite annotation-based test framework
- Modules marked "loaded from XAR" are installed via packages, not conf.xml
- Some modules (mail, sql, jndi, oracle) require external services
- `request`, `response`, `session` are HTTP-context-dependent
- `exi`, `exiftool`, `oracle`, `spatial` may not have their required dependencies available in all deployments
- `vector` is new in next-v2 for vector similarity search (DJL/HuggingFace)
