(: Merge all range index segments into a single optimized segment :)
(: This is a costly operation — use only for stable datasets :)
(: Requires DBA role :)
try {
  range:optimize(),
  "Range index optimized successfully"
} catch * {
  "range:optimize#0 — " || $err:description
}
