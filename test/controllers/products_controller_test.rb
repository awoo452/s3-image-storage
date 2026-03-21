require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "renders index" do
    get products_url

    assert_response :success
  end

  test "renders new" do
    get new_product_url

    assert_response :success
  end

  test "creates product" do
    assert_difference("Product.count", 1) do
      post products_url, params: { product: { name: "Widget" } }
    end

    product = Product.order(:created_at).last
    assert_redirected_to product_url(product)
  end

  test "renders show" do
    product = Product.create!(name: "Widget")

    get product_url(product)

    assert_response :success
  end

  test "renders edit" do
    product = Product.create!(name: "Widget")

    get edit_product_url(product)

    assert_response :success
  end

  test "updates product" do
    product = Product.create!(name: "Widget")

    patch product_url(product), params: { product: { name: "Widget 2" } }

    assert_redirected_to product_url(product)
    assert_equal "widget-2", product.reload.slug
  end

  test "destroys product" do
    product = Product.create!(name: "Widget")

    assert_difference("Product.count", -1) do
      delete product_url(product)
    end

    assert_redirected_to products_url
  end
end
