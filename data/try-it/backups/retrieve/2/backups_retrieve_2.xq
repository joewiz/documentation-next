(: Retrieve a backup archive and stream it to the HTTP response :)
"backups:retrieve($directory as xs:string, $name as xs:string) as empty-sequence() — streams a .zip backup file directly to the HTTP response; only reads .zip files in the specified directory"
