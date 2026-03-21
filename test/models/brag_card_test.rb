require "test_helper"

class BragCardTest < ActiveSupport::TestCase
  test "requires title" do
    card = BragCard.new

    assert_not card.valid?
    assert_includes card.errors[:title], "can't be blank"
  end
end
