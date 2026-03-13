# Config Reference

This file centralizes environment variables and how they are used.

## Required For S3 Uploads

1. `AWS_BUCKET` - target bucket name.
2. `AWS_REGION` or `AWS_DEFAULT_REGION` - AWS region.
3. `AWS_ACCESS_KEY_ID` - IAM access key.
4. `AWS_SECRET_ACCESS_KEY` - IAM secret.

## Optional Image Proxy (CloudFront Stack)

These are outputs from the CloudFront image proxy stack, not S3 itself:

1. `IMAGE_PROXY_BASE_URL` - CloudFront endpoint.
2. `IMAGE_PROXY_SIGNING_KEY` - HMAC signing key.

If these are missing, the app falls back to presigned S3 URLs.

## Postgres (Local Defaults)

If you do not use `DATABASE_URL`, the app uses:

1. `PGHOST` (default `localhost`)
2. `PGPORT` (default `5432`)
3. `PGUSER`
4. `PGPASSWORD`
