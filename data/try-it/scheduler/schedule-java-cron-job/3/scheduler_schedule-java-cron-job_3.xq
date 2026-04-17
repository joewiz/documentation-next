(: Schedule a Java job class using a cron expression :)
"scheduler:schedule-java-cron-job($java-classname as xs:string, $cron-expression as xs:string, $job-name as xs:string) as xs:boolean — schedules a Java class (must extend org.exist.scheduler.UserJavaJob) according to the cron expression"
