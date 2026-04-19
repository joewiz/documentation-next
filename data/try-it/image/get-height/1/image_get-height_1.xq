(: Get the height of an image in pixels :)
let $img := util:binary-doc("/db/apps/docs/data/try-it/image/data/sample.png")
return image:get-height($img)
