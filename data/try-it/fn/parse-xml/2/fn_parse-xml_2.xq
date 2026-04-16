let $value := "<greeting>Hello XQuery!</greeting>"
let $options := map {}
return
    parse-xml($value, $options)/greeting/string()