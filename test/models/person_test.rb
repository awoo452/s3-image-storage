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
    person = Person.new(name: "Ada", alt_image_keys: ["people/1/alt-1.jpg"])
    service = Struct.new(:presigned_url).new("https://example.com/alt.jpg")

    S3Service.stub(:new, service) do
      assert_equal ["https://example.com/alt.jpg"], person.alt_image_urls
    end
  end
end
