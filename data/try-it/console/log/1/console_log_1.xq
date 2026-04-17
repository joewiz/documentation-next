(: Log items to the default console channel :)
import module namespace console = "http://exist-db.org/xquery/console";

let $_ := console:log("Hello from the try-it widget!")
return
  "Logged message to default console channel (check browser dev tools)"
