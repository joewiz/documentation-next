(: Create a tar with a prefix stripped from entry names :)
try {
    let $entries := (
        <entry name="project/src/main.xq" type="text">1 + 1</entry>,
        <entry name="project/README.md" type="text"># Project</entry>
    )
    return compression:tar($entries, false(), "project/")
} catch * {
    "compression:tar#3 — like tar#2 but strips the given prefix from entry names. Error: " || $err:description
}
