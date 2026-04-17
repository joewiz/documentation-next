(: Schedule an XQuery periodically with unschedule-on-error flag :)
"scheduler:schedule-xquery-periodic-job($xquery-resource as xs:string, $period as xs:integer, $job-name as xs:string, $job-parameters as element()?, $delay as xs:integer, $repeat as xs:integer, $unschedule as xs:boolean) as xs:boolean — like #6, with a flag to auto-unschedule on XPathException"
