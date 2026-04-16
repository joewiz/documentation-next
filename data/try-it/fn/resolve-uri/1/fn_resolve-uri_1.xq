(: resolve-uri against an explicit base :)
let $href := "page.html"
let $base := "http://example.com/docs/"
return
    resolve-uri($href, $base)