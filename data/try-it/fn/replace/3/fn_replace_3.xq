let $text := "The quick brown fox jumps over the lazy dog"
return (
    replace($text, "fox", "cat"),
    replace($text, "\b\w", upper-case#1),
    replace("2026-04-16", "(\d{4})-(\d{2})-(\d{2})", "$2/$3/$1")
)
