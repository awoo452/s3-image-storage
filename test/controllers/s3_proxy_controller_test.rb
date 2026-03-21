require "test_helper"

class S3ProxyControllerTest < ActionDispatch::IntegrationTest
  Result = Struct.new(:redirect_url)

  test "returns not found when no redirect url" do
    S3Proxy::ShowData.stub(:call, Result.new(nil)) do
      get s3_media_url(key: "missing")
    end

    assert_response :not_found
  end

  test "returns forbidden for disallowed host" do
    S3Proxy::ShowData.stub(:call, Result.new("https://evil.example.com/file")) do
      get s3_media_url(key: "file")
    end

    assert_response :forbidden
  end

  test "redirects to allowed host" do
    with_env("AWS_BUCKET" => "my-bucket", "AWS_REGION" => "us-west-1") do
      url = "https://my-bucket.s3.us-west-1.amazonaws.com/people/1/main.jpg"
      S3Proxy::ShowData.stub(:call, Result.new(url)) do
        get s3_media_url(key: "people/1/main")
      end

      assert_response :redirect
      assert_equal url, response.headers["Location"]
    end
  end
end
