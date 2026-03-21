require "test_helper"

class BragCardsControllerTest < ActionDispatch::IntegrationTest
  test "renders index" do
    get brag_cards_url

    assert_response :success
  end

  test "renders new" do
    get new_brag_card_url

    assert_response :success
  end

  test "creates brag card" do
    assert_difference("BragCard.count", 1) do
      post brag_cards_url, params: { brag_card: { title: "Top Win" } }
    end

    brag_card = BragCard.order(:created_at).last
    assert_redirected_to brag_card_url(brag_card)
  end

  test "renders show" do
    brag_card = BragCard.create!(title: "Top Win")

    get brag_card_url(brag_card)

    assert_response :success
  end

  test "renders edit" do
    brag_card = BragCard.create!(title: "Top Win")

    get edit_brag_card_url(brag_card)

    assert_response :success
  end

  test "updates brag card" do
    brag_card = BragCard.create!(title: "Top Win")

    patch brag_card_url(brag_card), params: { brag_card: { title: "New Win" } }

    assert_redirected_to brag_card_url(brag_card)
    assert_equal "New Win", brag_card.reload.title
  end

  test "destroys brag card" do
    brag_card = BragCard.create!(title: "Top Win")

    assert_difference("BragCard.count", -1) do
      delete brag_card_url(brag_card)
    end

    assert_redirected_to brag_cards_url
  end
end
