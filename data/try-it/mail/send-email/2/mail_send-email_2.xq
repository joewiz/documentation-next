(: Send email via a JavaMail session :)
"mail:send-email($mail-handle as xs:long, $email as element()+) as empty-sequence() — sends email using the session; message format: <mail><from/><to/><subject/><message><text/><xhtml/></message><attachment filename='' mimetype=''>base64</attachment></mail>"
