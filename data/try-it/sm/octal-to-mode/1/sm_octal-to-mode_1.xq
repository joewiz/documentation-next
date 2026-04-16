(: Convert octal permissions to mode string :)
(
    "755: " || sm:octal-to-mode("755"),
    "644: " || sm:octal-to-mode("644"),
    "700: " || sm:octal-to-mode("700")
)
