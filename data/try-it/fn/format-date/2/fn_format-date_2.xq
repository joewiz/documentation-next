let $d := xs:date("2014-02-22")
return (
    format-date($d, "[Y0001]-[M01]-[D01]"),
    format-date($d, "[D1o] [MNn], [Y]", "en", (), ()),
    format-date($d, "[MNn] [D], [Y]", "en", (), ())
)
