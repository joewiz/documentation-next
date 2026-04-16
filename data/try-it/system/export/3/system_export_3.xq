(: system:export creates a database backup :)
try {
    let $dir := file:temp-dir() || "exist-backup-demo"
    return "Backup would be created at: " || $dir
} catch * { "export: " || $err:description }
