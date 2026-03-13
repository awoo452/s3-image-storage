# S3 Image Storage Reference

This Rails app is a reference implementation for S3-backed image workflows.
It standardizes how we name keys, upload images, and serve resized images
through CloudFront or presigned S3 URLs.

## What This App Covers

1. Public marketing images that live in `app/assets/images`.
2. Personal images with a main image plus multiple alt images.
3. Product images with main + alt image.
4. Brag card images with a single image per record.

## Image Strategy

Public and marketing related images stay in the Rails asset pipeline. These are images that will ALWAYS be public. Everything else is stored in S3 with object keys saved on the record.

Images are served in one of two ways:

1. CloudFront image proxy URLs when `IMAGE_PROXY_BASE_URL` and
   `IMAGE_PROXY_SIGNING_KEY` are set. (file sizing and delivery optimized)
2. Presigned S3 URLs when proxy settings are broken or missing. (large files, slow loading)

All dynamic image URLs are requested as WebP thumbnails using
`image_proxy_url` in `app/helpers/application_helper.rb`.

## Key Conventions

Product images:

1. Main image: `products/<slug>/main.<ext>`
2. Alt image: `products/<slug>/alt.<ext>`

Personal images:

1. Main image: `people/<id>/main.<ext>`
2. Alt images: `people/<id>/alt-<n>.<ext>`

Brag card images:

1. Main image: `brag-cards/<id>/main.<ext>`
2. id correlates to id of related record in the database

## Required Environment Variables

```
AWS_BUCKET
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

Use `s3-image-storage/.env.example` as a starting point for local development.
Buckets are not created by the app. Create them in AWS and set `AWS_BUCKET`.
Image proxy variables and setup live in `s3-image-storage/docs/IMAGE_PROXY.md`.

## Local Setup

1. Copy `s3-image-storage/.env.example` into your local env.
2. Create the database and run migrations.
3. Start the server.

This app uses PostgreSQL by default and does not require Active Storage for uploads.

## Image Proxy Docs

Detailed docs live in:

1. `s3-image-storage/docs/IMAGE_PROXY.md`
2. `s3-image-storage/docs/IMAGE_STRATEGY.md`
3. `s3-image-storage/docs/UPLOADS_TROUBLESHOOTING.md`
4. `s3-image-storage/docs/ARCHITECTURE.md`
5. `s3-image-storage/docs/BUCKET_STRATEGY.md`
6. `s3-image-storage/docs/CONFIG_REFERENCE.md`
7. `s3-image-storage/docs/S3_SETUP.md`
