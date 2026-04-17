(: Sync a database collection to a filesystem directory :)
try {
    let $dir := util:system-property("java.io.tmpdir") || "/exist-tryit-sync"
    let $_ := file:mkdirs($dir)
    let $report := file:sync(
        "/db/apps/docs/data/try-it/ft/data",
        $dir,
        map { "prune": false() }
    )
    let $synced := count($report//*[@name])
    let $_ := file:delete($dir)
    return (
        "Synced to " || $dir,
        "Files: " || $synced
    )
} catch * { "file:sync — " || $err:description }
