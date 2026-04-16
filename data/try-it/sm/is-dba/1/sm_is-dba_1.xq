(: Check if a user has DBA privileges :)
(
    "admin is DBA: " || sm:is-dba("admin"),
    "guest is DBA: " || sm:is-dba("guest")
)
