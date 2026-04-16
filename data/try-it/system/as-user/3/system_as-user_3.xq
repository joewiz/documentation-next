(: Execute an expression as a different user :)
system:as-user("guest", "guest",
    sm:id()//sm:username/string()
)
