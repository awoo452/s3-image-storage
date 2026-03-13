class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc).limit(5)
    @people = Person.order(created_at: :desc).limit(5)
    @brag_cards = BragCard.order(created_at: :desc).limit(5)
  end
end
