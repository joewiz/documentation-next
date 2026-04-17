(: List all backup archives in a directory :)
try {
  backups:list("/exist/data/export")
} catch * {
  "backups:list#1 — " || $err:description
}
