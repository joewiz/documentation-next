(: Get a function reference by QName and arity :)
let $fn := util:function(xs:QName("fn:upper-case"), 1)
return $fn("hello")