#!/bin/bash
#
# Throttled try-it validator.
# Validates .xq files one at a time, checking broker availability
# and memory before each query to avoid OOM crashes.
#
# Usage: bash tools/validate-tryit-throttled.sh [prefix...]
#   e.g.: bash tools/validate-tryit-throttled.sh system sm
#   or:   bash tools/validate-tryit-throttled.sh   (validates all)

set -euo pipefail

API="http://localhost:8080/exist/apps/exist-api/api/eval"
TRYIT_ROOT="/db/apps/docs/data/try-it"
MIN_FREE_MB=200      # Wait if free memory drops below this
MAX_ACTIVE_BROKERS=15 # Wait if too many brokers are busy
BATCH_SIZE=10         # Check status every N queries

ok=0
errors=0
error_list=""

# Get list of modules to validate
if [ $# -gt 0 ]; then
    prefixes="$@"
else
    prefixes=$(xst run "string-join(xmldb:get-child-collections('$TRYIT_ROOT'), ' ')" 2>&1)
fi

wait_for_capacity() {
    local retries=0
    while true; do
        local status
        status=$(xst run '
            let $avail := system:count-instances-available()
            let $active := system:count-instances-active()
            let $mem-free := system:get-memory-free() idiv 1048576
            return $avail || "|" || $active || "|" || $mem-free
        ' 2>&1)

        if [ $? -ne 0 ]; then
            echo "  [warn] Could not check status, waiting 5s..."
            sleep 5
            retries=$((retries + 1))
            if [ $retries -gt 6 ]; then
                echo "  [error] Server unreachable after 30s, aborting"
                exit 1
            fi
            continue
        fi

        local avail active mem_free
        IFS='|' read -r avail active mem_free <<< "$status"

        if [ "${mem_free:-0}" -lt $MIN_FREE_MB ] || [ "${active:-20}" -gt $MAX_ACTIVE_BROKERS ]; then
            echo "  [throttle] brokers=${active}/${avail} mem=${mem_free}MB — waiting 3s"
            sleep 3
        else
            break
        fi
    done
}

# Get all .xq paths for a module
get_paths() {
    local prefix="$1"
    xst run "
    declare function local:l(\$p) {
        (for \$r in xmldb:get-child-resources(\$p) where ends-with(\$r, '.xq')
         return \$p || '/' || \$r,
         for \$c in xmldb:get-child-collections(\$p) return local:l(\$p || '/' || \$c))
    };
    string-join(local:l('$TRYIT_ROOT/$prefix'), '|||')
    " 2>&1 | tr ',' '\n' | tr '|' '\n' | grep '/db/'
}

validate_one() {
    local dbpath="$1"
    local rel="${dbpath#$TRYIT_ROOT/}"

    local result
    result=$(xst run "
        let \$q := unparsed-text('$dbpath')
        return try { let \$_ := util:eval(\$q) return 'OK' }
        catch * { 'ERR: ' || substring(\$err:description, 1, 100) }
    " 2>&1)

    if [[ "$result" == "OK" ]] || [[ "$result" == *"OK"* && "$result" != *"ERR:"* ]]; then
        ok=$((ok + 1))
    else
        errors=$((errors + 1))
        local msg="${result#ERR: }"
        error_list="${error_list}${rel}  -->  ${msg}\n"
        echo "  FAIL: $rel"
    fi
}

echo "=== Throttled Try-it Validation ==="
echo ""

for prefix in $prefixes; do
    echo "--- $prefix ---"
    count=0

    while IFS= read -r path; do
        [ -z "$path" ] && continue

        if [ $((count % BATCH_SIZE)) -eq 0 ] && [ $count -gt 0 ]; then
            wait_for_capacity
        fi

        validate_one "$path"
        count=$((count + 1))
    done < <(get_paths "$prefix")

    echo "  $prefix: $count queries checked"
done

echo ""
echo "=== Summary ==="
echo "Total: $((ok + errors)) | OK: $ok | Errors: $errors"

if [ $errors -gt 0 ]; then
    echo ""
    echo "=== Errors ==="
    echo -e "$error_list"
fi
