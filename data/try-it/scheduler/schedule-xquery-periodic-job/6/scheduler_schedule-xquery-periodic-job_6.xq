(: Schedule an XQuery resource at a periodic interval :)
"scheduler:schedule-xquery-periodic-job($xquery-resource as xs:string, $period as xs:integer, $job-name as xs:string, $job-parameters as element()?, $delay as xs:integer, $repeat as xs:integer) as xs:boolean — schedules an XQuery with a period (ms), delay, and repeat count (-1 for forever); transitory"
