let $beginning-node := <item>value</item>
let $ending-node := <item>value</item>
let $make-fragment := true()
let $display-root-namespace := true()
return
    util:get-fragment-between($beginning-node, $ending-node, $make-fragment, $display-root-namespace)