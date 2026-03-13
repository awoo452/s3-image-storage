class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.order(created_at: :desc)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      errors = handle_product_uploads(@product)
      return handle_upload_errors(:new, errors) if errors.any?

      redirect_to @product, notice: "Product created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      errors = handle_product_uploads(@product)
      return handle_upload_errors(:edit, errors) if errors.any?

      redirect_to @product, notice: "Product updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.fetch(:product, {}).permit(:name)
  end

  def handle_upload_errors(view, errors)
    flash.now[:alert] = errors.join(" ")
    render view, status: :unprocessable_entity
  end

  def handle_product_uploads(product)
    errors = []

    image = params.dig(:product, :image)
    if image.present?
      result = Images::Uploader.call(record: product, uploaded: image, role: :main)
      if result.success?
        product.update(image_key: result.key)
      else
        errors << result.error
      end
    end

    alt_image = params.dig(:product, :alt_image)
    if alt_image.present?
      result = Images::Uploader.call(record: product, uploaded: alt_image, role: :alt)
      if result.success?
        product.update(image_alt_key: result.key)
      else
        errors << result.error
      end
    end

    errors
  end
end
