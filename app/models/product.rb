class Product < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug, if: -> { slug.blank? && name.present? }
  before_destroy :delete_s3_images

  def image_url
    S3Service.new.presigned_url(image_key)
  end

  def image_alt_url
    S3Service.new.presigned_url(image_alt_key)
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end

  def delete_s3_images
    key = image_key.presence || image_alt_key.presence
    return if key.blank?
    return if ENV["AWS_BUCKET"].blank?

    prefix = key.sub(/(main|alt)\\..*$/, "")
    S3Service.new.delete_prefix(prefix)
  rescue StandardError => e
    Rails.logger.error("S3 delete failed for product #{id}: #{e.message}")
  end
end
