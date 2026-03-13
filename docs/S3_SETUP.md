# S3 Setup

This file covers the S3-side work required to run this app.

## 1. Create The Bucket

Create one bucket per environment (recommended):

1. `s3-image-storage-dev`
2. `s3-image-storage-staging`
3. `s3-image-storage-prod`

Region should match `AWS_REGION` in your env.

## 2. Keep The Bucket Private

Block public access at the bucket level. This app serves images through
presigned URLs or the CloudFront image proxy.

## 3. Create IAM Credentials

Create an IAM user or role for the app with access limited to the bucket.

Minimum permissions:

1. `s3:PutObject`
2. `s3:GetObject`
3. `s3:DeleteObject`
4. `s3:ListBucket`

Scope the policy to the bucket and its objects.

## 4. Optional: CloudFront Image Proxy

If you use the CloudFront image proxy stack, follow
`s3-image-storage/docs/IMAGE_PROXY.md`. Configuration values are listed in
`s3-image-storage/docs/CONFIG_REFERENCE.md`.

## 5. Optional: CORS

This app uploads from the server, not the browser. CORS is not required
unless you plan to upload directly from the browser.

## 6. Optional: Versioning And Lifecycle

If you want extra safety and cost control:

1. Enable bucket versioning.
2. Add lifecycle rules for old versions and incomplete multipart uploads.

## 7. App Configuration

Set environment variables described in `s3-image-storage/docs/CONFIG_REFERENCE.md`.
