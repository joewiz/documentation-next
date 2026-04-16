try {
    let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
    let $start := $doc//stanza[1]
    let $end := $doc//stanza[2]
    return util:get-fragment-between($start, $end, true(), true())
} catch * { "Error: " || $err:description }