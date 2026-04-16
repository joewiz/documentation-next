(: Check if the current user has specific access to a resource :)
(
    "read /db/apps/docs: " || sm:has-access(xs:anyURI("/db/apps/docs"), "r"),
    "write /db/apps/docs: " || sm:has-access(xs:anyURI("/db/apps/docs"), "w"),
    "execute /db/apps/docs: " || sm:has-access(xs:anyURI("/db/apps/docs"), "x")
)
