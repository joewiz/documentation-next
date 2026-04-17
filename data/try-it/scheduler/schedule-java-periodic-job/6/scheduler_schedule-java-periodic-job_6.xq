(: Schedule a Java job class at a periodic interval :)
"scheduler:schedule-java-periodic-job($java-classname as xs:string, $period as xs:integer, $job-name as xs:string, $job-parameters as element()?, $delay as xs:integer, $repeat as xs:integer) as xs:boolean — schedules a Java class with a period (ms), delay, and repeat count (-1 for forever)"
