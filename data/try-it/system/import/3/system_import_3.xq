(: system:import restores a database backup — requires a valid backup path :)
try {
    "system:import() requires a valid backup directory"
} catch * { $err:description }
