(: Load an HTML page via HTTP :)
let $uri := "http://localhost:8080/exist/apps/exist-site-shell/"
return
    html-doc($uri)//title/string()