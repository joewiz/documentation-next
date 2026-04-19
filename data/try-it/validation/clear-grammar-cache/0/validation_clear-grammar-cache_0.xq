(: Clear all cached grammars and return the count of removed entries :)
let $removed := validation:clear-grammar-cache()
return "Cleared " || $removed || " cached grammar(s)"
