require "aws-sdk-s3"

class S3Service
  DEFAULT_EXPIRES_IN = 3600

  def initialize
    @config = s3_config
    @configured = required_config_present?
    return unless @configured

    @client = Aws::S3::Client.new(
      region: @config[:region],
      access_key_id: @config[:access_key_id],
      secret_access_key: @config[:secret_access_key]
    )
  end

  def configured?
    @configured
  end

  def upload(uploaded, key, content_type: nil)
    ensure_configured!("upload")
    io, inferred_type, close_io = normalize_upload(uploaded)
    content_type ||= inferred_type

    @client.put_object(
      bucket: @config[:bucket],
      key: key,
      body: io,
      content_type: content_type
    )

    key
  ensure
    io.close if close_io && io.respond_to?(:close)
  end

  def presigned_url(key, expires_in: DEFAULT_EXPIRES_IN)
    return nil unless configured?
    return nil if key.blank?

    cache_key = "s3:presign:#{key}:#{expires_in}"
    cache_ttl = [ expires_in.to_i - 60, 60 ].max

    Rails.cache.fetch(cache_key, expires_in: cache_ttl) do
      signer = Aws::S3::Presigner.new(client: @client)
      signer.presigned_url(
        :get_object,
        bucket: @config[:bucket],
        key: key,
        expires_in: expires_in
      )
    end
  end

  def list_keys(prefix)
    return [] unless configured?

    resp = @client.list_objects_v2(
      bucket: @config[:bucket],
      prefix: prefix
    )

    resp.contents.map(&:key)
  end

  def delete_prefix(prefix)
    return unless configured?

    continuation = nil

    loop do
      resp = @client.list_objects_v2(
        bucket: @config[:bucket],
        prefix: prefix,
        continuation_token: continuation
      )

      keys = resp.contents.map { |obj| { key: obj.key } }
      if keys.any?
        @client.delete_objects(
          bucket: @config[:bucket],
          delete: { objects: keys, quiet: true }
        )
      end

      break unless resp.is_truncated
      continuation = resp.next_continuation_token
    end
  end

  def delete_object(key)
    return unless configured?
    return if key.blank?

    @client.delete_object(bucket: @config[:bucket], key: key)
  rescue Aws::Errors::ServiceError => e
    Rails.logger.warn("S3 delete failed for #{key}: #{e.class} #{e.message}")
  end

  private

  def ensure_configured!(action)
    return if configured?

    raise "S3Service not configured for #{action}. Set AWS_REGION (or AWS_DEFAULT_REGION), AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_BUCKET."
  end

  def s3_config
    config = Rails.application.config_for(:s3) || {}

    {
      bucket: config["bucket"].presence || ENV["AWS_BUCKET"].presence,
      region: config["region"].presence || ENV["AWS_REGION"].presence || ENV["AWS_DEFAULT_REGION"].presence || "us-west-1",
      access_key_id: config["access_key_id"].presence || ENV["AWS_ACCESS_KEY_ID"].presence,
      secret_access_key: config["secret_access_key"].presence || ENV["AWS_SECRET_ACCESS_KEY"].presence
    }
  end

  def required_config_present?
    [ @config[:bucket], @config[:region], @config[:access_key_id], @config[:secret_access_key] ].all?(&:present?)
  end

  def normalize_upload(uploaded)
    if uploaded.respond_to?(:tempfile)
      io = File.open(uploaded.tempfile.path, "rb")
      return [ io, uploaded.content_type, true ]
    end

    if uploaded.is_a?(String)
      io = File.open(uploaded, "rb")
      return [ io, nil, true ]
    end

    if uploaded.respond_to?(:read)
      return [ uploaded, nil, false ]
    end

    raise ArgumentError, "Unsupported upload type: #{uploaded.class}"
  end
end
