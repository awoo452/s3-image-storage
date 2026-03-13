class Person < ApplicationRecord
  validates :name, presence: true

  attribute :alt_image_keys, default: []
  before_destroy :delete_s3_images

  def main_image_url
    S3Service.new.presigned_url(image_key)
  end

  def alt_image_urls
    Array(alt_image_keys).filter_map { |key| S3Service.new.presigned_url(key) }
  end

  private

  def delete_s3_images
    return if ENV["AWS_BUCKET"].blank?

    prefix = "people/#{id}/"
    S3Service.new.delete_prefix(prefix)
  rescue StandardError => e
    Rails.logger.error("S3 delete failed for person #{id}: #{e.message}")
  end
end
