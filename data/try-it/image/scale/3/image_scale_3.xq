(: Scale an image with dimension and media-type arguments :)
let $img := util:binary-doc("/db/apps/docs/data/try-it/image/data/sample.png")
let $scaled := image:scale($img, (5, 5), "image/png")
return map {
    "original-width": image:get-width($img),
    "scaled-width": image:get-width($scaled)
}
