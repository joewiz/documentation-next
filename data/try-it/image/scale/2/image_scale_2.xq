(: Scale an image using an options map :)
let $img := util:binary-doc("/db/apps/docs/data/try-it/image/data/sample.png")
let $scaled := image:scale($img, map {
    "source": map { "media-type": "image/png" },
    "destination": map { "max-height": 5, "max-width": 5 }
})
return map {
    "original-width": image:get-width($img),
    "original-height": image:get-height($img),
    "scaled-width": image:get-width($scaled),
    "scaled-height": image:get-height($scaled)
}
