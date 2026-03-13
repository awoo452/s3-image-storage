# Bucket Strategy

This app expects a single S3 bucket per environment and uses prefixes to
separate image categories.

## Recommended (Single Bucket Per Environment)

Use one bucket per environment, for example:

1. `s3-image-storage-dev`
2. `s3-image-storage-staging`
3. `s3-image-storage-prod`

Prefixes inside the bucket:

1. `products/`
2. `people/`
3. `brag-cards/`
4. Optional future prefixes: `events/`, `documents/`

This keeps permissions and CloudFront config simple while preserving clear
separation by prefix.

## Alternative (Multiple Buckets)

If you want dedicated buckets per category, we can extend `config/s3.yml`
to support per-model buckets. That is not implemented in this repo yet.

## Notes

Buckets are not created by the app. See `s3-image-storage/docs/S3_SETUP.md`
for provisioning steps and `s3-image-storage/docs/CONFIG_REFERENCE.md` for
environment variables.
