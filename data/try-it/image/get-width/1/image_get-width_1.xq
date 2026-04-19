(: Get the width of an image in pixels :)
let $img := util:binary-doc("/db/apps/docs/data/try-it/image/data/sample.png")
return image:get-width($img)
