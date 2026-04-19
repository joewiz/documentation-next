(: Create a zip with strip-prefix and explicit encoding :)
let $entries :=
    <entry name="notes/résumé.txt" type="text">Contenu en français</entry>
return compression:zip($entries, false(), "notes/", "UTF-8")
