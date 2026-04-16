(: Check if a function is available :)
(
    "fn:concat#2: " || system:function-available(xs:QName("fn:concat"), 2),
    "fn:nonexistent#0: " || system:function-available(xs:QName("fn:nonexistent"), 0)
)
