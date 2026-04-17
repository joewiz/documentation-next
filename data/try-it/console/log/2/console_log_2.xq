(: Log items to a specific named console channel :)
import module namespace console = "http://exist-db.org/xquery/console";

let $_ := console:log("demo", ("Item count: ", count(1 to 10)))
return
  "Logged to 'demo' channel (check browser dev tools or Monex)"
