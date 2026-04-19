(: Create a tar with strip-prefix and explicit encoding :)
try {
    let $entries :=
        <entry name="notes/résumé.txt" type="text">Contenu en français</entry>
    return compression:tar($entries, false(), "notes/", "UTF-8")
} catch * {
    "compression:tar#4 — like tar#3 but with explicit filename encoding. Error: " || $err:description
}
