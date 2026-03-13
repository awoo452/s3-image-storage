class BragCardsController < ApplicationController
  before_action :set_brag_card, only: %i[show edit update destroy]

  def index
    @brag_cards = BragCard.order(created_at: :desc)
  end

  def show
  end

  def new
    @brag_card = BragCard.new
  end

  def edit
  end

  def create
    @brag_card = BragCard.new(brag_card_params)
    if @brag_card.save
      errors = handle_brag_card_upload(@brag_card)
      return handle_upload_errors(:new, errors) if errors.any?

      redirect_to @brag_card, notice: "Brag card created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @brag_card.update(brag_card_params)
      errors = handle_brag_card_upload(@brag_card)
      return handle_upload_errors(:edit, errors) if errors.any?

      redirect_to @brag_card, notice: "Brag card updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brag_card.destroy
    redirect_to brag_cards_path, notice: "Brag card deleted."
  end

  private

  def set_brag_card
    @brag_card = BragCard.find(params[:id])
  end

  def brag_card_params
    params.fetch(:brag_card, {}).permit(:title)
  end

  def handle_upload_errors(view, errors)
    flash.now[:alert] = errors.join(" ")
    render view, status: :unprocessable_entity
  end

  def handle_brag_card_upload(brag_card)
    errors = []
    image = params.dig(:brag_card, :image)
    if image.present?
      result = Images::Uploader.call(record: brag_card, uploaded: image, role: :main)
      if result.success?
        brag_card.update(image_key: result.key)
      else
        errors << result.error
      end
    end
    errors
  end
end
