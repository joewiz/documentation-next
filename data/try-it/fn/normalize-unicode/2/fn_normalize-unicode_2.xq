let $value := "À"  (: A + combining grave :)
let $form := "NFC"
return
    normalize-unicode($value, $form)