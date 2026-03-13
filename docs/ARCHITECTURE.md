# Architecture

This doc explains the core moving pieces in the S3 image workflow.

## Services

`S3Service` in `app/services/s3_service.rb` owns all S3 interactions:

1. Uploads to S3.
2. Presigned URL generation.
3. Prefix deletes and list operations.

`Images::KeyBuilder` in `app/services/images/key_builder.rb` owns all key formats.

`Images::Uploader` in `app/services/images/uploader.rb` validates uploads and
calls `S3Service`.

`S3Proxy::ShowData` in `app/services/s3_proxy/show_data.rb` builds redirect
data for the S3 proxy controller.

## Helpers

`image_proxy_url` in `app/helpers/application_helper.rb` builds CloudFront
proxy URLs when configured and falls back to presigned S3 URLs otherwise.

`fallback_image_tag` swaps in `branding/logo.svg` when a request fails.

## Controllers

Each resource controller uses `Images::Uploader` to store images and then
saves the resulting S3 key.

The `S3ProxyController` allows the app to redirect to a presigned URL for
private objects without leaking credentials.

## Models

`Product` stores main and alt image keys.

`Person` stores a main image key plus a JSON array of alt image keys.

`BragCard` stores a single image key.

## Why Not Active Storage

We avoid Active Storage here because the established apps use direct S3 keys,
presigned URLs, and CloudFront image proxy resizing. This repo stays aligned
with that flow to keep migrations and shared logic straightforward.
