require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  test "renders index" do
    get people_url

    assert_response :success
  end

  test "renders new" do
    get new_person_url

    assert_response :success
  end

  test "creates person" do
    assert_difference("Person.count", 1) do
      post people_url, params: { person: { name: "Ada" } }
    end

    person = Person.order(:created_at).last
    assert_redirected_to person_url(person)
  end

  test "renders show" do
    person = Person.create!(name: "Ada")

    get person_url(person)

    assert_response :success
  end

  test "renders edit" do
    person = Person.create!(name: "Ada")

    get edit_person_url(person)

    assert_response :success
  end

  test "updates person" do
    person = Person.create!(name: "Ada")

    patch person_url(person), params: { person: { name: "Ada Lovelace" } }

    assert_redirected_to person_url(person)
    assert_equal "Ada Lovelace", person.reload.name
  end

  test "destroys person" do
    person = Person.create!(name: "Ada")

    assert_difference("Person.count", -1) do
      delete person_url(person)
    end

    assert_redirected_to people_url
  end
end
