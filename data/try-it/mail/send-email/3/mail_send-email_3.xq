(: Send email via SMTP server directly :)
"mail:send-email($email as element()+, $server as xs:string?, $charset as xs:string?) as xs:boolean+ — sends email through the SMTP server; if $server is empty, tries to use local sendmail"
