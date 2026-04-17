(: Register a persistent login and generate a one-time token :)
"plogin:register($user as xs:string, $password as xs:string?, $timeToLive as xs:duration, $onLogin as function(*)?) as item()* — authenticates the user and generates a one-time login token; the callback receives ($token, $user, $password, $timeToLive)"
