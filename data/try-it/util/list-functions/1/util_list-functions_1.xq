try {
    let $fns := util:list-functions("http://exist-db.org/xquery/util")
    return "util module has " || count($fns) || " functions"
} catch * { "Error: " || $err:description }