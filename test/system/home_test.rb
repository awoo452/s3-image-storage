require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visits home page" do
    visit root_path

    assert_text "S3 Image Storage Reference"
    assert_text "Collections"
  end
end
