# S3 Image Storage Reference

This Rails app is a reference implementation for S3-backed image workflows. It standardizes how we name keys, upload images, and serve resized images through CloudFront or presigned S3 URLs.

## Features

- Public marketing images that live in `app/assets/images`.
- Personal images with a main image plus multiple alt images.
- Product images with main + alt image.
- Brag card images with a single image per record.

### Image Strategy

Public and marketing related images stay in the Rails asset pipeline. These are images that will always be public. Everything else is stored in S3 with object keys saved on the record.

Images are served in one of two ways:

1. CloudFront image proxy URLs when `IMAGE_PROXY_BASE_URL` and `IMAGE_PROXY_SIGNING_KEY` are set (file sizing and delivery optimized).
2. Presigned S3 URLs when proxy settings are broken or missing (large files, slow loading).

All dynamic image URLs are requested as WebP thumbnails using `image_proxy_url` in `app/helpers/application_helper.rb`.

### Key Conventions

Product images:
- Main image: `products/<slug>/main.<ext>`
- Alt image: `products/<slug>/alt.<ext>`

Personal images:
- Main image: `people/<id>/main.<ext>`
- Alt images: `people/<id>/alt-<n>.<ext>`

Brag card images:
- Main image: `brag-cards/<id>/main.<ext>`
- id correlates to id of related record in the database

### Image Proxy Docs

Detailed docs live in:
- `s3-image-storage/docs/IMAGE_PROXY.md`
- `s3-image-storage/docs/IMAGE_STRATEGY.md`
- `s3-image-storage/docs/UPLOADS_TROUBLESHOOTING.md`
- `s3-image-storage/docs/ARCHITECTURE.md`
- `s3-image-storage/docs/BUCKET_STRATEGY.md`
- `s3-image-storage/docs/CONFIG_REFERENCE.md`
- `s3-image-storage/docs/S3_SETUP.md`

## Setup

Required environment variables:

- `AWS_BUCKET`
- `AWS_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Use `s3-image-storage/.env.example` as a starting point for local development. Buckets are not created by the app. Create them in AWS and set `AWS_BUCKET`. Image proxy variables and setup live in `s3-image-storage/docs/IMAGE_PROXY.md`.

Local setup:

1. Copy `s3-image-storage/.env.example` into your local env.
2. Create the database and run migrations.

This app uses PostgreSQL by default and does not require Active Storage for uploads.

## Run

1. `bin/rails server`

## Tests

1. `bin/rails test`

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md) for notable changes.
