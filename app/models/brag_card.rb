class BragCard < ApplicationRecord
  validates :title, presence: true
  before_destroy :delete_s3_images

  def image_url
    S3Service.new.presigned_url(image_key)
  end

  private

  def delete_s3_images
    return if ENV["AWS_BUCKET"].blank?

    prefix = "brag-cards/#{id}/"
    S3Service.new.delete_prefix(prefix)
  rescue StandardError => e
    Rails.logger.error("S3 delete failed for brag card #{id}: #{e.message}")
  end
end
