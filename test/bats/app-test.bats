#!/usr/bin/env bats

# Application-level tests for documentation-next.
# Expects the app installed at http://localhost:8080/exist/apps/docs/

BASE_URL="http://localhost:8080/exist/apps/docs"

# ─── Page loads ────────────────────────────────────────────────────────

@test "Landing page loads (article index)" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/")
  [ "$status" = "200" ]
}

@test "Function browser loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/functions/")
  [ "$status" = "200" ]
}

@test "Article index loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/articles/")
  [ "$status" = "200" ]
}

@test "Search page loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/search")
  [ "$status" = "200" ]
}

@test "Admin page loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/admin/")
  [ "$status" = "200" ]
}

@test "404 page returns for invalid path" {
  result=$(curl -s "$BASE_URL/nonexistent")
  echo "$result" | grep -q 'Page Not Found'
}

# ─── Articles ──────────────────────────────────────────────────────────

@test "DocBook article renders" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/articles/docker")
  [ "$status" = "200" ]
}

@test "Article has title" {
  result=$(curl -s "$BASE_URL/articles/docker")
  echo "$result" | grep -qi 'docker'
}

@test "Article index shows categories" {
  result=$(curl -s "$BASE_URL/articles/")
  echo "$result" | grep -q 'article-category'
}

# ─── Functions ─────────────────────────────────────────────────────────

@test "Function module browser shows categories" {
  result=$(curl -s "$BASE_URL/functions/")
  echo "$result" | grep -q 'module-category'
}

@test "Function module detail loads (fn)" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/functions/fn/")
  [ "$status" = "200" ]
}

@test "Function module detail shows functions" {
  result=$(curl -s "$BASE_URL/functions/fn/")
  echo "$result" | grep -q 'function-head'
}

# ─── Search ────────────────────────────────────────────────────────────

@test "Search with query returns results" {
  result=$(curl -s "$BASE_URL/search?q=store")
  echo "$result" | grep -q 'search-result'
}

@test "Search shows result count" {
  result=$(curl -s "$BASE_URL/search?q=store")
  echo "$result" | grep -q 'search-summary'
}

# ─── Regeneration ──────────────────────────────────────────────────────

@test "XQDoc regeneration returns JSON status" {
  result=$(curl -s -X POST "$BASE_URL/api/xqdoc/regenerate")
  echo "$result" | grep -q '"status"'
}

# ─── Static resources ─────────────────────────────────────────────────

@test "docs.css loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/resources/css/docs.css")
  [ "$status" = "200" ]
}

@test "docs.js loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/resources/js/docs.js")
  [ "$status" = "200" ]
}

@test "highlight.js loads" {
  status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/resources/js/vendor/highlight.min.js")
  [ "$status" = "200" ]
}

# ─── Accessibility ─────────────────────────────────────────────────────

@test "Search input has aria-label" {
  result=$(curl -s "$BASE_URL/search")
  echo "$result" | grep -q 'aria-label'
}

@test "Breadcrumb has aria-label" {
  result=$(curl -s "$BASE_URL/functions/")
  echo "$result" | grep -q 'aria-label="Breadcrumb"'
}

# ─── XQSuite tests ────────────────────────────────────────────────────

@test "XQSuite tests pass" {
  result=$(curl -s "http://localhost:8080/exist/rest/db/apps/docs/test/xqs/test-runner.xq")
  # Check that no failures or errors are reported
  ! echo "$result" | grep -q '"failure"'
  ! echo "$result" | grep -q '"error"'
}
