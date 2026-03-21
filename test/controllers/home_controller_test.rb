require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "renders home page" do
    get root_url

    assert_response :success
    assert_match "S3 Image Storage Reference", response.body
  end
end
