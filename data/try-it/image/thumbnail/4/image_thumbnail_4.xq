(: Generate thumbnails from a collection of images :)
(: This creates thumbnails in a subcollection relative to the source :)
try {
    image:thumbnail(
        xs:anyURI("/db/apps/docs/data/try-it/image/data"),
        xs:anyURI("rel:/thumbs"),
        (5, 5),
        "thumb_"
    )
} catch * {
    "image:thumbnail#4 — generates thumbnails for all images in a collection. Error: " || $err:description
}
