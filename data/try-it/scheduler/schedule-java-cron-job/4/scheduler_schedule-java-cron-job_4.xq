(: Schedule a Java job class with cron expression and parameters :)
"scheduler:schedule-java-cron-job($java-classname as xs:string, $cron-expression as xs:string, $job-name as xs:string, $job-parameters as element()?) as xs:boolean — like #3, but with job parameters passed as <parameters><param name='...' value='...'/></parameters>"
