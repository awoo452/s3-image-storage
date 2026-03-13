# Image Strategy

This document explains the three S3-backed image patterns and the public
asset pattern used in this app.

## S3 Usage Inventory (Source Apps)

This section lists the known S3 usage patterns across the existing apps
and how they map to this reference repo.

Covered in this repo:

1. S3 uploads with presigned URL reads (`S3Service`).
2. CloudFront image proxy URLs with HMAC signing (`image_proxy_url`).
3. Proxy fallback to presigned S3 URLs.
4. Product images with main + alt.
5. Personal images with main + multiple alt images.
6. Brag card images with a single image per record.
7. Prefix delete for cleanup on record destroy.

Documented but not implemented as models:

1. Event images (`events/<id>/main.<ext>` + `events/<id>/alt.<ext>`).
2. Document image arrays and metadata-driven public flags.
3. Product variant discovery by listing prefix and choosing preferred ext.
4. Heroku-admin-only upload redirect flows.

If you want any of these implemented as first-class models, say the word and
we will add them.

## Event Images (Current Convention)

Events currently follow the same pattern as products (main + alt) while we
prepare to move to `main + alt1 + alt2 + alt3`:

1. Main image: `events/<id>/main.<ext>`
2. Alt image: `events/<id>/alt.<ext>`

When we migrate to multiple alts, the key pattern will match `people`:

1. Alt images: `events/<id>/alt-<n>.<ext>`

## Public And Marketing Images

Public images that are not tied to a database record live in
`app/assets/images`.

Examples:

1. Branding and logos.
2. Marketing images used on static pages.
3. Layout and UI assets.

These are served by the asset pipeline and do not use S3.

## Personal Images

Personal images are stored in S3 and referenced by a `Person` record.

Key format:

1. Main image: `people/<id>/main.<ext>`
2. Alt images: `people/<id>/alt-<n>.<ext>`

Notes:

1. Alt images can be uploaded in batches.
2. Alt indexes are appended in order of upload.
3. Keys are stored in `people.image_key` and `people.alt_image_keys`.

## Product Images

Product images are stored in S3 and referenced by a `Product` record.

Key format:

1. Main image: `products/<slug>/main.<ext>`
2. Alt image: `products/<slug>/alt.<ext>`

Notes:

1. Slug is generated from the product name.
2. Keys are stored in `products.image_key` and `products.image_alt_key`.

## Brag Card Images

Brag card images are stored in S3 and referenced by a `BragCard` record.

Key format:

1. Main image: `brag-cards/<id>/main.<ext>`

Notes:

1. Brag cards use the record ID so new cards never collide.
2. Keys are stored in `brag_cards.image_key`.
