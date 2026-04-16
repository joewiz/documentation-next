# Try-It Module Coverage

Status of try-it query coverage across all registered eXist-db modules.

**Legend:** Done = all functions have try-it files and pass validation

## W3C Standard Libraries

- [x] **fn** (344 functions) — `http://www.w3.org/2005/xpath-functions`
- [x] **array** (38 functions) — `http://www.w3.org/2005/xpath-functions/array`
- [x] **map** (20 functions) — `http://www.w3.org/2005/xpath-functions/map`
- [x] **math** (18 functions) — `http://www.w3.org/2005/xpath-functions/math`

## EXPath Standard Libraries

- [x] **bin** (40 functions) — `http://expath.org/ns/binary`
- [x] **file** (58 functions) — `http://expath.org/ns/file` (uses `exfile:` prefix in queries)
- [ ] **http** (3 functions) — `http://expath.org/ns/http-client`
- [ ] **crypto** (8 functions) — `http://expath.org/ns/crypto`
- [ ] **zip** (6 functions) — `http://expath.org/ns/zip`

## Core eXist-db Modules — Priority

- [x] **util** (114 functions) — `http://exist-db.org/xquery/util` — scaffolds, needs validation pass
- [x] **xmldb** (50 functions) — `http://exist-db.org/xquery/xmldb` — scaffolds, needs validation pass
- [x] **system** (39 functions) — `http://exist-db.org/xquery/system` — scaffolds, needs validation pass
- [x] **sm** (59 functions) — `http://exist-db.org/xquery/securitymanager` — scaffolds, needs validation pass
- [x] **request** (31 functions) — `http://exist-db.org/xquery/request` — scaffolds, needs validation pass
- [x] **response** (10 functions) — `http://exist-db.org/xquery/response` — scaffolds, needs validation pass
- [ ] **kwic** — KWIC module (see [KWIC article](http://localhost:8080/exist/apps/docs/articles/kwic))
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
- [ ] **console** (3 functions) — `http://exist-db.org/xquery/console`
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
- [ ] **md** (5 functions) — `http://exist-db.org/xquery/markdown`
- [ ] **cqlparser** (1 function) — `http://exist-db.org/xquery/cqlparser`
- [ ] **simpleql** (1 function) — `http://exist-db.org/xquery/simple-ql`

## RESTXQ & API Modules

- [ ] **rest** (3 functions) — `http://exquery.org/ns/restxq`
- [ ] **exrest** (8 functions) — `http://exquery.org/ns/restxq/exist`
- [ ] **req** (19 functions) — `http://exquery.org/ns/request`
- [ ] **lsp** (17 functions) — `http://exist-db.org/xquery/lsp`
- [ ] **api** (0 functions) — `http://exist-db.org/xquery/api`

## Other

- [ ] **jndi** (8 functions) — `http://exist-db.org/xquery/jndi`
- [ ] **ws** (5 functions) — `http://exist-db.org/xquery/websocket`
- [ ] **plogin** (3 functions) — `http://exist-db.org/xquery/persistentlogin`

---

## Summary

| Status | Count | Functions |
|--------|-------|-----------|
| Done | 8 modules | ~533 functions |
| Priority (next) | 8 modules | ~316 functions |
| Remaining | ~30 modules | ~250 functions |
| **Total** | ~46 modules | ~1099 functions |

## Notes

- The `kwic` module is not a registered Java module — it's an XQuery library at `resource:org/exist/xquery/lib/kwic.xqm`
- The `test` module is the XQSuite annotation-based test framework
- Some modules (mail, sql, jndi) require external services and may need mock/try-catch patterns
- Modules like `request`, `response`, `session` are HTTP-context-dependent and need careful handling
