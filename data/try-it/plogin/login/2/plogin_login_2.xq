(: Log in using a persistent login token :)
"plogin:login($token as xs:string, $onLogin as function(*)?) as item()* — logs in the user using a one-time token; the callback receives a new token for the next request; the old token is invalidated"
