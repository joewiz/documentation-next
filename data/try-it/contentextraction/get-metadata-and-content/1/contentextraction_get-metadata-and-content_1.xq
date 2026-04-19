(: Extract both metadata and text content from binary data :)
let $text := util:string-to-binary("Hello, this is sample content for extraction.")
return contentextraction:get-metadata-and-content($text)
