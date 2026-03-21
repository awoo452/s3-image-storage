require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "requires name" do
    person = Person.new

    assert_not person.valid?
    assert_includes person.errors[:name], "can't be blank"
  end

  test "defaults alt image keys" do
    person = Person.new(name: "Ada")

    assert_equal [], person.alt_image_keys
  end

  test "alt image urls uses s3 service" do
    person = Person.new(name: "Ada", alt_image_keys: [ "people/1/alt-1.jpg" ])
    service = Object.new
    service.define_singleton_method(:presigned_url) do |key, _expires_in = nil|
      raise "unexpected key #{key}" unless key == "people/1/alt-1.jpg"
      "https://example.com/alt.jpg"
    end

    with_stubbed_method(S3Service, :new, service) do
      assert_equal [ "https://example.com/alt.jpg" ], person.alt_image_urls
    end
  end
end
