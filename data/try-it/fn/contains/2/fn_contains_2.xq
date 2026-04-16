let $languages := ("XQuery", "XSLT", "XPath", "JavaScript", "Python")
for $lang in $languages
where contains($lang, "X")
return $lang
