(: Filter ngram matches with a custom function :)
let $data := collection("/db/apps/docs/data/try-it/ngram/data")
let $hits := $data//person[ngram:contains(description, "xml")]
return
    ngram:filter-matches(
        $hits/description,
        function($match) {
            (: Only keep matches in lowercase — exclude "XML" abbreviation :)
            lower-case($match) = $match
        }
    )
