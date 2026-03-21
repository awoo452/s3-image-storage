require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "requires name" do
    product = Product.new

    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "sets slug from name" do
    product = Product.create!(name: "Sample Product")

    assert_equal "sample-product", product.slug
  end

  test "image url uses s3 service" do
    product = Product.new(name: "Widget", slug: "widget", image_key: "products/1/main.jpg")
    service = Struct.new(:presigned_url).new("https://example.com/main.jpg")

    with_stubbed_method(S3Service, :new, service) do
      assert_equal "https://example.com/main.jpg", product.image_url
    end
  end
end
