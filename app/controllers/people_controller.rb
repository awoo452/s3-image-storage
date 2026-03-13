class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]

  def index
    @people = Person.order(created_at: :desc)
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      errors = handle_person_uploads(@person)
      return handle_upload_errors(:new, errors) if errors.any?

      redirect_to @person, notice: "Person created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @person.update(person_params)
      errors = handle_person_uploads(@person)
      return handle_upload_errors(:edit, errors) if errors.any?

      redirect_to @person, notice: "Person updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to people_path, notice: "Person deleted."
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.fetch(:person, {}).permit(:name)
  end

  def handle_upload_errors(view, errors)
    flash.now[:alert] = errors.join(" ")
    render view, status: :unprocessable_entity
  end

  def handle_person_uploads(person)
    errors = []

    image = params.dig(:person, :image)
    if image.present?
      result = Images::Uploader.call(record: person, uploaded: image, role: :main)
      if result.success?
        person.update(image_key: result.key)
      else
        errors << result.error
      end
    end

    alt_uploads = Array(params.dig(:person, :alt_images)).reject(&:blank?)
    if alt_uploads.any?
      current = Array(person.alt_image_keys)
      starting_index = current.length + 1

      alt_uploads.each_with_index do |upload, idx|
        result = Images::Uploader.call(
          record: person,
          uploaded: upload,
          role: :alt,
          index: starting_index + idx
        )

        if result.success?
          current << result.key
        else
          errors << result.error
        end
      end

      person.update(alt_image_keys: current) if current != person.alt_image_keys
    end

    errors
  end
end
