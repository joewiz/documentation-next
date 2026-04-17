(: Retrieve a resource from an installed package :)
(: Get the expath-pkg.xml descriptor from the docs app :)
let $pkg := "http://exist-db.org/apps/docs"
let $descriptor := repo:get-resource($pkg, "expath-pkg.xml")
return
  if (exists($descriptor)) then
    parse-xml(util:binary-to-string($descriptor))
  else
    "Resource not found in package " || $pkg
