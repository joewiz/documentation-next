(: Schedule an XQuery with cron, parameters, and unschedule-on-error flag :)
"scheduler:schedule-xquery-cron-job($xquery-resource as xs:string, $cron-expression as xs:string, $job-name as xs:string, $job-parameters as element()?, $unschedule as xs:boolean) as xs:boolean — like #4, with a flag to auto-unschedule the job if an XPathException is raised (default true)"
