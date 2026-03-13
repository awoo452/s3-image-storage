# Image Proxy

This doc combines two reference sections:

1. Image Proxy: How Images Are Served.
2. Image Proxy Setup (Repeatable).

## Image Proxy: How Images Are Served

### Purpose

Images are delivered through the image proxy when configured. This keeps S3
private while serving resized images.

### Proxy Base URL

The base URL comes from `IMAGE_PROXY_BASE_URL` (CloudFront endpoint from the
stack). These values are outputs of the image proxy stack, not S3 itself.
`image_proxy_url` builds the final URL with width, height, fit, and format
parameters.

### Signed Requests

Requests are signed with `IMAGE_PROXY_SIGNING_KEY` (HMAC). Invalid signatures
return 403.

### Key Format

Keys are raw S3 object keys with extensions. Example:

1. `documents/12/0.png`

### Fallback Behavior

If proxy config is missing, the app uses presigned S3 URLs. If the S3 object
is missing or the request fails because of bad credentials or region settings,
the image swaps to `branding/logo.svg` in the browser.

### Common Key Examples

Examples from source apps (not all exist in this repo):

1. `documents/<id>/<file>`
2. `games/<id>/<game_image>`
3. `blog/<image>`
4. `projects/<image>`
5. `services/<image>`
6. `landscaping/<image>`
7. `about/<index>.png`
8. `branding/logo.svg`

## Image Proxy Setup (Repeatable)

### Purpose

This is the repeatable setup for the AWS image proxy stack and app config.

### Template URL

Use the Lambda template URL:

```
https://solutions-reference.s3.amazonaws.com/dynamic-image-transformation-for-amazon-cloudfront/latest/dynamic-image-transformation-for-amazon-cloudfront-lambda.template
```

### Secret Format

Secrets Manager secret is JSON with a `signing-key` field. Example secret name:
`getawd-thumbnail`. CloudFormation uses `SecretsManagerSecretParameter` as the
secret name and `SecretsManagerKeyParameter` as `signing-key`.

### CloudFormation Parameters

Use these parameters:

1. `EnableDefaultFallbackImageParameter=No`
2. `FallbackImageS3KeyParameter=(empty)`
3. `CloudFrontPriceClassParameter=PriceClass_All`
4. `SecretsManagerKeyParameter=signing-key`
5. `EnableSignatureParameter=Yes`
6. `CorsEnabledParameter=No`
7. `AutoWebPParameter=No`
8. `UseExistingCloudFrontDistributionParameter=No`
9. `ExistingCloudFrontDistributionIdParameter=(empty)`
10. `FallbackImageS3BucketParameter=(empty)`
11. `SecretsManagerSecretParameter=<secret name>`
12. `LogRetentionPeriodParameter=180`
13. `CorsOriginParameter=*`
14. `EnableS3ObjectLambdaParameter=No`
15. `OriginShieldRegionParameter=Disabled`
16. `SourceBucketsParameter=<bucket or bucket1,bucket2>`
17. `DeployDemoUIParameter=No`

### Outputs To Save

Save the `ApiEndpoint` from stack Outputs. That is `IMAGE_PROXY_BASE_URL`.

### Heroku Config Vars

Heroku vars:

1. `IMAGE_PROXY_BASE_URL`
2. `IMAGE_PROXY_SIGNING_KEY`
3. `AWS_ACCESS_KEY_ID`
4. `AWS_SECRET_ACCESS_KEY`
5. `AWS_REGION`
6. `AWS_BUCKET`

### Local Development (.env)

`dotenv-rails` loads `.env`, but if ENV values are blank the AWS SDK uses
shared credentials from `~/.aws/credentials`. Region comes from
`AWS_REGION` or `AWS_DEFAULT_REGION` or defaults to `us-west-1` via
`config/s3.yml`.

### Verification

Working state: image URLs start with the CloudFront endpoint and include
signature params. If you see direct presigned S3 URLs, the proxy is not
active.

### Common Failures

1. `CheckSecretsManager` means the secret is missing, in the wrong region, or
   missing the `signing-key` field.
2. `SignatureDoesNotMatch` means `IMAGE_PROXY_SIGNING_KEY` does not match the
   `signing-key` value.
3. `AuthorizationQueryParametersError` means the request was signed with the
   wrong region.

### Next App Checklist

1. Create a secret in `us-west-1` with JSON containing `signing-key`.
2. Create the stack with the template URL.
3. Set `SourceBucketsParameter`.
4. Copy `ApiEndpoint`.
5. Set Heroku vars.
6. Restart the app.
