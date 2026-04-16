(: Convert a permission mode string to octal :)
(
    sm:mode-to-octal("rwxr-xr-x"),
    sm:mode-to-octal("rw-r--r--"),
    sm:mode-to-octal("rwx------")
)
