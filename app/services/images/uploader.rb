module Images
  class Uploader
    MAX_IMAGE_SIZE = 15.megabytes
    ALLOWED_IMAGE_TYPES = %w[image/heic image/heif image/jpeg image/png image/gif image/webp].freeze

    Result = Struct.new(:success?, :key, :error, keyword_init: true)

    def self.call(record:, uploaded:, role:, index: nil)
      new(record: record, uploaded: uploaded, role: role, index: index).call
    end

    def initialize(record:, uploaded:, role:, index:)
      @record = record
      @uploaded = uploaded
      @role = role
      @index = index
    end

    def call
      return Result.new(success?: false, error: "No upload provided.") if @uploaded.blank?
      return Result.new(success?: false, error: validation_error) if validation_error

      key = Images::KeyBuilder.for(
        record: @record,
        role: @role,
        index: @index,
        filename: @uploaded.original_filename,
        content_type: @uploaded.content_type
      )

      begin
        S3Service.new.upload(@uploaded, key)
      rescue StandardError => e
        Rails.logger.error("S3 upload failed for #{@record.class} #{@record.id}: #{e.class} #{e.message}")
        return Result.new(success?: false, error: "Upload failed. Please try again.")
      end

      Result.new(success?: true, key: key)
    end

    private

    def validation_error
      return "Upload must include a content type and size." unless @uploaded.respond_to?(:content_type) && @uploaded.respond_to?(:size)
      return "Upload must be under #{MAX_IMAGE_SIZE / 1.megabyte}MB." if @uploaded.size > MAX_IMAGE_SIZE
      return "Upload must be one of: #{ALLOWED_IMAGE_TYPES.join(', ')}." unless ALLOWED_IMAGE_TYPES.include?(@uploaded.content_type)

      nil
    end
  end
end
