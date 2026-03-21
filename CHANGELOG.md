# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.7] - 2026-03-20
### Fixed
- Fixed RuboCop spacing for array literals in tests.

## [0.1.6] - 2026-03-20
### Fixed
- Replaced test stubs with a local helper to avoid missing stub support.
- Aligned product slug update expectations with model behavior.
- Adjusted S3 service doubles to accept the expected presigned URL arguments.

## [0.1.5] - 2026-03-20
### Added
- Added controller coverage for home, products, people, brag cards, and the S3 proxy.
- Added model coverage for product slugging, person defaults, and brag card validation.
- Added a system smoke test for the home page and an env helper for S3 proxy tests.

## [0.1.4] - 2026-03-19
### Changed
- Refreshed Gemfile.lock via bundle update for Ruby 4.0.2.

## [0.1.3] - 2026-03-19
### Changed
- Pinned Ruby to 4.0.2 across runtime files and Gemfile.lock.

## [0.1.2] - 2026-03-19
### Removed
- Removed view class attributes to keep the template backend-only.
- Removed application CSS and stylesheet tag to keep the template backend-only.

## [0.1.1] - 2026-03-12
### Added
- Stuff to make github stop yelling at me

### Changed
- Other stuff to make github stop yelling at me

## [0.1.0] - 2026-03-12
1. Added S3 upload service, key builder, and image proxy helpers.
2. Added reference models for products, people, and brag cards.
3. Added controllers and views for S3-backed uploads.
4. Added image proxy and uploads documentation.
5. Other related documentation for supporting processes.
