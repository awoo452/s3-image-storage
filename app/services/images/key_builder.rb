module Images
  class KeyBuilder
    class << self
      def for(record:, role:, filename:, index: nil, content_type: nil)
        ext = file_extension(filename, content_type)

        case record
        when Product
          role_name = role.to_s == "alt" ? "alt" : "main"
          base = "products/#{record.slug.presence || record.id}"
          "#{base}/#{role_name}#{ext}"
        when Person
          base = "people/#{record.id}"
          if role.to_s == "alt"
            idx = index.to_i
            idx = 1 if idx <= 0
            "#{base}/alt-#{idx}#{ext}"
          else
            "#{base}/main#{ext}"
          end
        when BragCard
          base = "brag-cards/#{record.id}"
          "#{base}/main#{ext}"
        else
          raise ArgumentError, "Unsupported record type for key builder: #{record.class}"
        end
      end

      def file_extension(filename, content_type)
        ext = File.extname(filename.to_s).downcase
        return ext if ext.present?

        case content_type
        when "image/jpeg" then ".jpg"
        when "image/png" then ".png"
        when "image/gif" then ".gif"
        when "image/webp" then ".webp"
        when "image/heic" then ".heic"
        when "image/heif" then ".heif"
        else ".img"
        end
      end
    end
  end
end
