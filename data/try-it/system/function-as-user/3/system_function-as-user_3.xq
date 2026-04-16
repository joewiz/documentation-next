(: Run a function as a different user :)
system:function-as-user("guest", "guest", function() {
    sm:id()//sm:username/string()
})
