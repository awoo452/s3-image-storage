# Uploads Troubleshooting

Uploads require AWS credentials and `AWS_BUCKET` to be set. See
`s3-image-storage/docs/CONFIG_REFERENCE.md`.

Product image keys:

1. `products/<slug>/main.<ext>`
2. `products/<slug>/alt.<ext>`

Personal image keys:

1. `people/<id>/main.<ext>`
2. `people/<id>/alt-<n>.<ext>`

Brag card image keys:

1. `brag-cards/<id>/main.<ext>`

Event image keys (reference from other apps):

1. `events/<id>/main.<ext>`
2. `events/<id>/alt.<ext>`

If uploads fail outside the production admin host, redirect to the admin host
used for uploads.
