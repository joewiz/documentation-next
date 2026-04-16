let $d := xs:date("2014-02-22")
return (
    format-date($d, "[D1o] [MNn], [Y]", "en", (), ()),
    format-date($d, "[D]. [MNn] [Y]", "de", (), ()),
    format-date($d, "[Y]年[M01]月[D01]日", "ja", (), ())
)
