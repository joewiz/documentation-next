(: Crop a region from an image :)
let $img := util:binary-doc("/db/apps/docs/data/try-it/image/data/sample.png")
(: Crop a 5x5 region from the top-left corner (x1, y1, x2, y2) :)
let $cropped := image:crop($img, (0, 0, 5, 5), "image/png")
return map {
    "original-width": image:get-width($img),
    "cropped-width": image:get-width($cropped)
}
