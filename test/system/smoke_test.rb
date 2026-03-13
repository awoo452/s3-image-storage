require "application_system_test_case"

class SmokeTest < ApplicationSystemTestCase
  test "homepage loads" do
    visit root_url
    assert_text "S3 Image Storage Reference"
  end
end
