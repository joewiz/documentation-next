(: Schedule an XQuery resource using a cron expression :)
"scheduler:schedule-xquery-cron-job($xquery-resource as xs:string, $cron-expression as xs:string, $job-name as xs:string) as xs:boolean — schedules an XQuery (e.g., /db/foo.xql) on a cron schedule; runs as guest; transitory (lost on restart)"
