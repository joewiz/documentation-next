let $value := "<greeting>Hello <b>XQuery</b>!</greeting>"
return
    parse-xml($value)//b/string()