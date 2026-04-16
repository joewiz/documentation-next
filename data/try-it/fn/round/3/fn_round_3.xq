(: round#3 with precision and rounding mode :)
let $arg := 2.55
let $precision := 1
return
    round($arg, $precision, "half-to-even")